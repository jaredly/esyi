open Opam;
open Npm;
open Shared;

open SolveUtils;

module T = {
  type manifest = [
    | `OpamFile(OpamFile.manifest)
    | `PackageJson(Yojson.Basic.json)
  ];

  type cache = {
    opamOverrides: list((string, Types.opamRange, string)),
    npmPackages: Hashtbl.t(string, Yojson.Basic.json),
    opamPackages: Hashtbl.t(string, OpamFile.manifest),
    versions: VersionCache.t,
    manifests: Hashtbl.t((string, Lockfile.realVersion), (manifest, list(Types.dep), list(Types.dep))),
  };

  type state = {
    cache,
    /* universe: Cudf.universe, */
    cudfVersions: CudfVersions.t,
  };
};
open T;

let initCache = config => {
  versions: {
    availableNpmVersions: Hashtbl.create(100),
    availableOpamVersions: Hashtbl.create(100),
    config,
  },
  opamOverrides: OpamOverrides.getOverrides(config.Types.esyOpamOverrides),
  npmPackages: Hashtbl.create(100),
  opamPackages: Hashtbl.create(100),
  manifests: Hashtbl.create(100),
};


/**
 *
 * Order of operations:
 * - solve for real deps of the main module
 * - [list of solved deps], [list of build deps requests for MAIN]
 * - can look in the manifest cache for build deps of the solved deps
 *
 * - now I want to dedup where possible, so I'm installing the minimum amount of build deps
 * - now I have a list of list((name, list(realVersion))) that is the versions of the build deps to install
 * - for each of those, do `solveDeps(cache, depsOfThatOneRealVersion)`
 *   - build deps aren't allowed to depend on each other I don't think
 * - that will result in new buildDeps needed
 * - churn until we're done
 *
 * - when making the lockfile, for each build dep that a thing wants, find one that we've chosen, whichever is most recent probably
 *
 */


let cudfDep = (owner, universe, cudfVersions, (name, source)) => {
  let available = Cudf.lookup_packages(universe, name);
  let matching = available
  |> List.filter(CudfVersions.matchesSource(source, cudfVersions));
  let final = (if (matching == []) {
    let hack = switch source {
    | Opam(opamVersionRange) => {
      /* print_endline("Trying to convert from pseudo-npm"); */
      let nonNpm = tryConvertingOpamFromNpm(opamVersionRange);
      /* print_endline(Shared.GenericVersion.view(Shared.Types.viewOpamConcrete, nonNpm)); */
      available |> List.filter(CudfVersions.matchesSource(Opam(nonNpm), cudfVersions))
    }
    | _ => []
    };
    switch hack {
    | [] => {
      /* We know there are packages that want versions of ocaml we don't support, it's ok */
      if (name == "ocaml") {
        []
      } else {
        print_endline("🛑 🛑 🛑  Requirement unsatisfiable " ++ owner ++ " wants " ++ name ++ " at version " ++ Types.viewReq(source));
        available |> List.iter(package => print_endline("  - " ++ Lockfile.viewRealVersion(CudfVersions.getRealVersion(cudfVersions, package))));
        []
      }
    }
    | matching => matching
    }
  } else {
    matching
  })
  |> List.map(package => (package.Cudf.package, Some((`Eq, package.Cudf.version))));
  /** If no matching packages, make a requirement for a package that doesn't exist. */
  final == [] ? [("**not-a-packge%%%", Some((`Eq, 10000000000)))] : final
};

let rec addPackage = (name, realVersion, version, deps, buildDeps, state, universe, manifest) => {
  CudfVersions.update(state.cudfVersions, name, realVersion, version);
  Hashtbl.replace(state.cache.manifests, (name, realVersion), (manifest, deps, buildDeps));
  List.iter(addToUniverse(state, universe), deps);
  let package = {
    ...Cudf.default_package,
    package: name,
    version,
    conflicts: [(name, None)],
    depends: List.map(cudfDep(name ++ " (at " ++ Shared.Lockfile.viewRealVersion(realVersion) ++ ")", universe, state.cudfVersions), deps)
  };
  Cudf.add_package(universe, package);
}

and addToUniverse = (state, universe, (name, source)) => {
  VersionCache.getAvailableVersions(state.cache.versions, (name, source)) |> List.iter(versionPlus => {
    let (realVersion, i) = switch versionPlus {
    | `Github(v) => (`Github(v), 1)
    | `Opam(v, _, i) => (`Opam(v), i)
    | `Npm(v, _, i) => (`Npm(v), i)
    };
    if (!Hashtbl.mem(state.cudfVersions.lookupIntVersion, (name, realVersion))) {
      let (manifest, deps, buildDeps) = getCachedManifest(state.cache.opamOverrides, state.cache.manifests, (name, versionPlus));
      addPackage(name, realVersion, i, deps, buildDeps, state, universe, manifest)
    }
  });
};

let rootName = "*root*";

let solveDeps = (cache, deps) => {
  if (deps == []) {
    []
  } else {

    let universe = Cudf.empty_universe();
    let state = {
      cache,
      cudfVersions: CudfVersions.init(),
    };

    /** This is where most of the work happens, file io, network requests, etc. */
    List.iter(addToUniverse(state, universe), deps);

    /** Here we invoke the solver! Might also take a while, but probably won't */
    let cudfDeps = List.map(cudfDep(rootName, universe, state.cudfVersions), deps);
    switch (runSolver(rootName, cudfDeps, universe)) {
    | None => failwith("Unable to resolve")
    | Some(packages) => {
      /* print_endline("Installed packages:"); */
      packages
      |> List.filter(p => p.Cudf.package != rootName)
      |> List.map(p => {
        let version = CudfVersions.getRealVersion(state.cudfVersions, p);

        let (manifest, requestedDeps, requestedBuildDeps) = Hashtbl.find(state.cache.manifests, (p.Cudf.package, version));
        (p.Cudf.package, version, manifest, requestedDeps, requestedBuildDeps)
      })
    }
    }
  };
};