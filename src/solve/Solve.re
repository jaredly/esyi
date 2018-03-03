open Opam;
open Npm;
open Shared;

open SolveUtils;

type manifest = [
  | `OpamFile(OpamFile.manifest)
  | `PackageJson(Yojson.Basic.json)
];

Printexc.record_backtrace(true);

type cache = {
  opamOverrides: list((string, Types.opamRange, string)),
  npmPackages: Hashtbl.t(string, Yojson.Basic.json),
  opamPackages: Hashtbl.t(string, OpamFile.manifest),
  allBuildDeps: Hashtbl.t(string, list((Lockfile.realVersion, list(Lockfile.solvedDep), list(Types.dep)))),
  versions: VersionCache.t,
  manifests: Hashtbl.t((string, Lockfile.realVersion), (manifest, list(Types.dep), list(Types.dep))),
};

type state = {
  cache,
  universe: Cudf.universe,
  lookupRealVersion: Hashtbl.t((string, int), Lockfile.realVersion),
  lookupIntVersion: Hashtbl.t((string, Lockfile.realVersion), int),
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

let getRealVersion = (versionCache, package) => {
  switch (Hashtbl.find(versionCache, (package.Cudf.package, package.Cudf.version))) {
  | exception Not_found => {
    failwith("Tried to find a package that wasn't listed in the versioncache " ++ package.Cudf.package ++ " " ++ string_of_int(package.Cudf.version))
  }
  | version => version
  };
};

let matchesSource = (source, versionCache, package) => {
  let version = switch (Hashtbl.find(versionCache, (package.Cudf.package, package.Cudf.version))) {
  | exception Not_found => {
    failwith("Tried to find a package that wasn't listed in the versioncache " ++ package.Cudf.package ++ " " ++ string_of_int(package.Cudf.version))
  }
  | version => version
  };
  satisfies(version, source)
};


let cudfDep = (owner, state, (name, source)) => {
  let available = Cudf.lookup_packages(state.universe, name);
  let matching = available
  |> List.filter(matchesSource(source, state.lookupRealVersion));
  let final = (if (matching == []) {
    let hack = switch source {
    | Opam(opamVersionRange) => {
      /* print_endline("Trying to convert from pseudo-npm"); */
      let nonNpm = tryConvertingOpamFromNpm(opamVersionRange);
      /* print_endline(Shared.GenericVersion.view(Shared.Types.viewOpamConcrete, nonNpm)); */
      available |> List.filter(matchesSource(Opam(nonNpm), state.lookupRealVersion))
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
        available |> List.iter(package => print_endline("  - " ++ Lockfile.viewRealVersion(getRealVersion(state.lookupRealVersion, package))));
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

let rec addPackage = (name, realVersion, version, deps, buildDeps, state, manifest) => {
  Hashtbl.replace(state.lookupIntVersion, (name, realVersion), version);
  Hashtbl.replace(state.lookupRealVersion, (name, version), realVersion);
  Hashtbl.replace(state.cache.manifests, (name, realVersion), (manifest, deps, buildDeps));
  List.iter(addToUniverse(state), deps);
  let package = {
    ...Cudf.default_package,
    package: name,
    version,
    conflicts: [(name, None)],
    depends: List.map(cudfDep(name ++ " (at " ++ Shared.Lockfile.viewRealVersion(realVersion) ++ ")", state), deps)
  };
  Cudf.add_package(state.universe, package);
}

and addToUniverse = (state, (name, source)) => {
  VersionCache.getAvailableVersions(state.cache.versions, (name, source)) |> List.iter(versionPlus => {
    let (realVersion, i) = switch versionPlus {
    | `Github(v) => (`Github(v), 1)
    | `Opam(v, _, i) => (`Opam(v), i)
    | `Npm(v, _, i) => (`Npm(v), i)
    };
    if (!Hashtbl.mem(state.lookupIntVersion, (name, realVersion))) {
      let (manifest, deps, buildDeps) = getCachedManifest(state.cache.opamOverrides, state.cache.manifests, (name, versionPlus));
      addPackage(name, realVersion, i, deps, buildDeps, state, manifest)
    }
  });
};

let rootName = "*root*";

let getOpamFile = (manifest, opamOverrides, name, version) => {
  switch manifest {
  | `PackageJson(_) => None
  | `OpamFile({OpamFile.fileName}) => Some(OpamFile.toPackageJson(opamOverrides, fileName, name, version))
  }
};

let rec solveDeps = (cache, deps) => {
  if (deps == []) {
    ([], [])
  } else {

    let state = {
      cache,
      universe: Cudf.empty_universe(),
      lookupRealVersion: Hashtbl.create(100),
      lookupIntVersion: Hashtbl.create(100),
    };

    /** This is where most of the work happens, file io, network requests, etc. */
    /* print_endline("adding everyrthing to the universe"); */
    List.iter(addToUniverse(state), deps);

    /* let opamOverrides = Opam.OpamOverrides.getOverrides(config.Types.esyOpamOverrides); */
    /* print_endline("Running the SMT solver"); */
    /** Here we invoke the solver! Might also take a while, but probably won't */
    let cudfDeps = List.map(cudfDep(rootName, state), deps);
    switch (runSolver(rootName, cudfDeps, state.universe)) {
    | None => failwith("Unable to resolve")
    | Some(packages) => {
      /* print_endline("Installed packages:"); */
      packages
      |> List.filter(p => p.Cudf.package != rootName)
      |> List.fold_left(((deps, buildDeps), p) => {
        let version = Hashtbl.find(state.lookupRealVersion, (p.Cudf.package, p.Cudf.version));
        let (manifest, _myDeps, myBuildDeps) = Hashtbl.find(state.cache.manifests, (p.Cudf.package, version));
        let (requestedDeps, requestedBuildDeps) = Manifest.getDeps(manifest);
        ([{
          Lockfile.name: p.Cudf.package,
          version: version,
          requestedDeps,
          requestedBuildDeps,
          source: lockDownSource(switch version {
          | `Github(user, repo, ref) => Types.PendingSource.GithubSource(user, repo, ref)
          | _ => Manifest.getArchive(manifest)}) ,
          opamFile: getOpamFile(manifest, cache.opamOverrides, p.Cudf.package, version),
          unpackedLocation: "",
          buildDeps: [],
        }, ...deps], myBuildDeps @ buildDeps)
      }, ([], []))
    }
    }
  };
}

and processBuildDeps = (cache, deps) => {
  let unmetDeps = deps |> List.filter(((name, req)) => {
    switch (Hashtbl.find(cache.allBuildDeps, name)) {
    | exception Not_found => true
    | items => !List.exists(((version, _, _)) => satisfies(version, req), items)
    }
  });
  let toInstall = unmetDeps |> List.map(((name, req)) => {
    /* print_endline(name); */
    let available = VersionCache.getAvailableVersions(cache.versions, (name, req));
    let work = List.find_all(version => satisfies(toRealVersion(version), req), available);
    /* print_endline(name ++ ": " ++ Types.viewReq(req)); */
    if (work == []) {
      failwith("No working versions found for " ++ name ++ " " ++ Shared.Types.viewReq(req));
    };
    let got = work |> List.sort((a, b) => sortRealVersions(toRealVersion(b), toRealVersion(a))) |> List.hd;
    /* print_endline("Chose " ++ Lockfile.viewRealVersion(toRealVersion(got))); */
    (name, got);
  }) |> List.sort_uniq(compare);

  print_endline("Chose these dev deps");
  let allBuildDeps = toInstall |> List.map(((name, versionPlus)) => {
    /* print_endline(name ++ ": " ++ Lockfile.viewRealVersion(toRealVersion(versionPlus))); */
    let (manifest, deps, buildDeps) = getCachedManifest(cache.opamOverrides, cache.manifests, (name, versionPlus));
    let (solvedDeps, collectedBuildDeps) = solveDeps(cache, deps);

    let current = switch (Hashtbl.find(cache.allBuildDeps, name)) {
    | exception Not_found => []
    | items => items
    };
    Hashtbl.replace(cache.allBuildDeps, name, [
      (toRealVersion(versionPlus), solvedDeps, buildDeps),
      ...current
    ]);

    buildDeps @ collectedBuildDeps
  }) |> List.concat;
  if (allBuildDeps != []) {
    processBuildDeps(cache, allBuildDeps)
  };
};

let resolveBuildDep = (cache, (name, req)) => {
  switch (Hashtbl.find(cache, name)) {
  | exception Not_found => failwith("No build deps during final resolution for " ++ name)
  | items => {
    let work = List.find_all(((version, _, _)) => satisfies(version, req), items)
    |> List.map(((version, _, _)) => version);
    /* print_endline(name ++ ": " ++ Types.viewReq(req)); */
    (name, work |> List.sort((a, b) => sortRealVersions(b, a)) |> List.hd);
  }
  }
};

let addBuildDepsForSolvedDep = (cache, solvedDep) => {
  let key = (solvedDep.Lockfile.name, solvedDep.Lockfile.version);
  let (_, _, buildDeps) = switch (Hashtbl.find(cache.manifests, key)) {
  | exception Not_found => failwith("No manifest during final resolution")
  | x => x
  };

  {
    ...solvedDep,
    Lockfile.buildDeps: List.map(resolveBuildDep(cache.allBuildDeps), buildDeps)
  }
};

let checkRepositories = config => {
  ensureGitRepo("https://github.com/esy-ocaml/esy-opam-override", config.Shared.Types.esyOpamOverrides);
  ensureGitRepo("https://github.com/ocaml/opam-repository", config.Shared.Types.opamRepository);
};

let solve = (config, manifest) => {
  checkRepositories(config);
  let cache = {
    versions: {
      availableNpmVersions: Hashtbl.create(100),
      availableOpamVersions: Hashtbl.create(100),
      config,
    },
    opamOverrides: OpamOverrides.getOverrides(config.Types.esyOpamOverrides),
    npmPackages: Hashtbl.create(100),
    opamPackages: Hashtbl.create(100),
    allBuildDeps: Hashtbl.create(100),
    manifests: Hashtbl.create(100),
  };

  let (deps, buildDeps, devDeps) = switch manifest {
  | `OpamFile(file) => OpamFile.process(file)
  | `PackageJson(json) => PackageJson.process(json)
  };
  let buildDeps = buildDeps @ devDeps;

  let (solvedDeps, collectedBuildDeps) = solveDeps(cache, deps);

  print_endline("Now dev deps");
  processBuildDeps(cache, buildDeps @ collectedBuildDeps);

  let allBuildDeps = Hashtbl.fold(
    (key, items, res) => [(key,
      items |> List.map(((realVersion, solvedDeps, buildDeps)) => {
        let (manifest, _myDeps, myBuildDeps) = try(Hashtbl.find(cache.manifests, (key, realVersion))) {
        | Not_found => failwith("BAD NEWS no manifest for you")
        };
        let (requestedDeps, requestedBuildDeps) = Manifest.getDeps(manifest);
        ({
          Lockfile.name: key,
          source: lockDownSource(Manifest.getArchive(manifest)),
          opamFile: getOpamFile(manifest, cache.opamOverrides, key, realVersion),
          version: realVersion,
          unpackedLocation: "",
          requestedDeps,
          requestedBuildDeps,
          buildDeps: List.map(resolveBuildDep(cache.allBuildDeps), buildDeps)
        }, List.map(addBuildDepsForSolvedDep(cache), solvedDeps),)
    })
    ), ...res],
    cache.allBuildDeps,
    []
  );

  {
    Lockfile.requestedDeps: deps,
    requestedBuildDeps: buildDeps,
    allBuildDeps,
    solvedDeps: List.map(addBuildDepsForSolvedDep(cache), solvedDeps),
    solvedBuildDeps: List.map(resolveBuildDep(cache.allBuildDeps), buildDeps)
  };
};
