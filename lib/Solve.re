
type manifest = [
  | `OpamFile(OpamFile.manifest)
  | `PackageJson(Yojson.Basic.json)
];

Printexc.record_backtrace(true);

let satisfies = (realVersion, req) => {
  switch (req, realVersion) {
  | (Types.Github(source), `Github(source_)) when source == source_ => true
  | (Npm(semver), `Npm(s)) when Semver.matches(s, semver) => true
  | (Opam(semver), `Opam(s)) when Semver.matches(s, semver) => true
  | _ => false
  }
};

let sortRealVersions = (a, b) => {
  switch (a, b) {
  | (`Github(a), `Github(b)) => 0
  | (`Npm(a), `Npm(b)) => VersionNumber.compareVersionNumbers(a, b)
  | (`Opam(a), `Opam(b)) => VersionNumber.compareVersionNumbers(a, b)
  | _ => 0
  }
};

type cache = {
  config: Types.config,
  opamOverrides: list((string, Semver.semver, string)),
  npmPackages: Hashtbl.t(string, Yojson.Basic.json),
  opamPackages: Hashtbl.t(string, OpamFile.manifest),
  allBuildDeps: Hashtbl.t(string, list((Lockfile.realVersion, list(Lockfile.solvedDep), list(Types.dep)))),
  availableNpmVersions: Hashtbl.t(string, list((VersionNumber.versionNumber, Yojson.Basic.json))),
  availableOpamVersions: Hashtbl.t(string, list((VersionNumber.versionNumber, OpamFile.thinManifest))),
  manifests: Hashtbl.t((string, Lockfile.realVersion), (manifest, list(Types.dep), list(Types.dep))),
};

let toRealVersion = versionPlus => switch versionPlus {
| `Github(x) => `Github(x)
| `Npm(x, _) => `Npm(x)
| `Opam(x, _) => `Opam(x)
};

type state = {
  cache,
  universe: Cudf.universe,
  lookupRealVersion: Hashtbl.t((string, int), Lockfile.realVersion),
  lookupIntVersion: Hashtbl.t((string, Lockfile.realVersion), int),
};

let versionTicker = ref(0);

let nextVersion = () => {
  incr(versionTicker);
  versionTicker^
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

let cudfDep = (state, (name, source)) => {
  let available = Cudf.lookup_packages(state.universe, name);
  let num = List.length(available);
  let available = available
  |> List.filter(matchesSource(source, state.lookupRealVersion))
  |> List.map(package => (package.Cudf.package, Some((`Eq, package.Cudf.version))));
  if (available == []) {
    print_endline("Opam semver wrong " ++ Types.viewReq(source));
    failwith("No package found for " ++ name ++ " when converting to a cudf dep (started with " ++ string_of_int(num) ++ ")")
  } else {
    available
  }
};

let getAvailableVersions = (cache, (name, source)) => {
  switch source {
  | Types.Github(url) => {
    [`Github(url)]
  }
  | Npm(semver) => {
    if (!Hashtbl.mem(cache.availableNpmVersions, name)) {
      Hashtbl.replace(cache.availableNpmVersions, name, Registry.getFromNpmRegistry(name));
    };
    let available = Hashtbl.find(cache.availableNpmVersions, name);
    available
    |> List.filter(((version, json)) => Semver.matches(version, semver))
    |> List.map(((version, json)) => `Npm(version, json));
  }

  | Opam(semver) => {
    if (!Hashtbl.mem(cache.availableOpamVersions, name)) {
      Hashtbl.replace(cache.availableOpamVersions, name, Registry.getFromOpamRegistry(cache.config, name))
    };
    let available = Hashtbl.find(cache.availableOpamVersions, name);
    available
    |> List.filter(((version, path)) => Semver.matches(version, semver))
    |> List.map(((version, path)) => `Opam(version, path));
  }
  | _ => []
  }
};

let getCachedManifest = (opamOverrides, cache, (name, versionPlus)) => {
  let realVersion = toRealVersion(versionPlus);
  switch (Hashtbl.find(cache, (name, realVersion))) {
  | exception Not_found => {
    let manifest = switch versionPlus {
    | `Github(url) => Registry.getGithubManifest(url)
    | `Npm(version, json) => `PackageJson(json)
    | `Opam(version, path) => `OpamFile(OpamFile.getManifest(opamOverrides, path))
    };
    let (deps, buildDeps) = Manifest.getDeps(manifest);
    let res = (manifest, deps, buildDeps);
    Hashtbl.replace(cache, (name, realVersion), res);
    res
  }
  | x => x
  };
};

let rec addPackage = (name, realVersion, deps, buildDeps, state, manifest) => {
  let version = nextVersion();
  Hashtbl.replace(state.lookupIntVersion, (name, realVersion), version);
  Hashtbl.replace(state.lookupRealVersion, (name, version), realVersion);
  Hashtbl.replace(state.cache.manifests, (name, realVersion), (manifest, deps, buildDeps));
  List.iter(addToUniverse(state), deps);
  let package = {
    ...Cudf.default_package,
    package: name,
    version,
    conflicts: [(name, None)],
    depends: List.map(cudfDep(state), deps)
  };
  Cudf.add_package(state.universe, package);
}

and addToUniverse = (state, (name, source)) => {
  getAvailableVersions(state.cache, (name, source)) |> List.iter(versionPlus => {
    let realVersion = toRealVersion(versionPlus);
    if (!Hashtbl.mem(state.lookupIntVersion, (name, realVersion))) {
      let (manifest, deps, buildDeps) = getCachedManifest(state.cache.opamOverrides, state.cache.manifests, (name, versionPlus));
      addPackage(name, realVersion, deps, buildDeps, state, manifest)
    }
  });
};

let rootName = "*root*";

let rootPackage = (deps, state) => {
  {
    ...Cudf.default_package,
    package: rootName,
    version: nextVersion(),
    depends: List.map(cudfDep(state), deps)
  }
};

let makeRequest = (deps, state) => {
  let root = rootPackage(deps, state);
  Cudf.add_package(state.universe, root);
  {
    ...Cudf.default_request,
    install: [(root.Cudf.package, Some((`Eq, root.Cudf.version)))]
  }
};

 let getOpamFile = manifest => {
   switch manifest {
   | `PackageJson(_) => None
   | `OpamFile({OpamFile.fileName}) => Some(fileName)
   }
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

let rec solveDeps = (cache, deps) => {
  let state = {
    cache,
    universe: Cudf.empty_universe(),
    lookupRealVersion: Hashtbl.create(100),
    lookupIntVersion: Hashtbl.create(100),
  };

  if (deps == []) {
    ([], [])
  } else {

    /** This is where most of the work happens, file io, network requests, etc. */
    List.iter(addToUniverse(state), deps);

    let request = makeRequest(deps, state);
    let preamble = Cudf.default_preamble;
    /** Here we invoke the solver! Might also take a while, but probably won't */
    switch (Mccs.resolve_cudf(~verbose=true, ~timeout=5., "-notuptodate", (preamble, state.universe, request))) {
    | None => failwith("Unable to resolve")
    | Some((a, universe)) => {
      let packages = Cudf.get_packages(~filter=(p => p.Cudf.installed), universe);
      print_endline("Installed packages:");
      packages
      |> List.filter(p => p.Cudf.package != rootName)
      |> List.fold_left(((deps, buildDeps), p) => {
        let version = try(Hashtbl.find(state.lookupRealVersion, (p.Cudf.package, p.Cudf.version))) {
        | Not_found => failwith("BAD NEWS version somehow got lost")
        };
        print_endline(p.Cudf.package ++ " @ " ++ Lockfile.viewRealVersion(version));
        let (manifest, _myDeps, myBuildDeps) = try(Hashtbl.find(state.cache.manifests, (p.Cudf.package, version))) {
        | Not_found => failwith("BAD NEWS no manifest for you")
        };
        ([{
          Lockfile.name: p.Cudf.package,
          version: version,
          source: Manifest.getArchive(manifest),
          opamFile: getOpamFile(manifest),
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
    let available = getAvailableVersions(cache, (name, req));
    let work = List.find_all(version => satisfies(toRealVersion(version), req), available);
    /* print_endline(name ++ ": " ++ Types.viewReq(req)); */
    let got = work |> List.sort((a, b) => sortRealVersions(toRealVersion(b), toRealVersion(a))) |> List.hd;
    /* print_endline("Chose " ++ Lockfile.viewRealVersion(toRealVersion(got))); */
    (name, got);
  }) |> List.sort_uniq(compare);

  print_endline("Chose these dev deps");
  let allBuildDeps = toInstall |> List.map(((name, versionPlus)) => {
    print_endline(name ++ ": " ++ Lockfile.viewRealVersion(toRealVersion(versionPlus)));
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

let solve = (config, manifest) => {
  let cache = {
    config,
    opamOverrides: OpamOverrides.getOverrides(config.Types.esyOpamOverrides),
    npmPackages: Hashtbl.create(100),
    opamPackages: Hashtbl.create(100),
    allBuildDeps: Hashtbl.create(100),
    availableNpmVersions: Hashtbl.create(100),
    availableOpamVersions: Hashtbl.create(100),
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
        ({
        Lockfile.name: key,
        source: Manifest.getArchive(manifest),
        opamFile: getOpamFile(manifest),
        version: realVersion,
        unpackedLocation: "",
        buildDeps: List.map(resolveBuildDep(cache.allBuildDeps), buildDeps)
        }, List.map(addBuildDepsForSolvedDep(cache), solvedDeps),)
    })
    ), ...res],
    cache.allBuildDeps,
    []
  );

    /* ...Lockfile.empty, */
  {
    Lockfile.requestedDeps: deps,
    requestedBuildDeps: buildDeps,
    allBuildDeps,
    solvedDeps: List.map(addBuildDepsForSolvedDep(cache), solvedDeps),
    solvedBuildDeps: List.map(resolveBuildDep(cache.allBuildDeps), buildDeps)
  };
};
