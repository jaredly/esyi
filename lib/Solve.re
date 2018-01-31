
type config = [
  | `OpamFile(OpamParserTypes.opamfile)
  | `PackageJson(Yojson.Basic.json)
];

Printexc.record_backtrace(true);

type realVersion = [
  | `Github(string)
  | `Npm(Types.triple)
  | `Opam(Types.triple)
  | `Git(string)
];

let satisfies = (realVersion, req) => {
  switch (req, realVersion) {
  | (Types.Github(source), `Github(source_)) when source == source_ => true
  | (Npm(semver), `Npm(s)) when NpmSemver.matches(s, semver) => true
  | (Opam(semver), `Opam(s)) when NpmSemver.matches(s, semver) => true
  | _ => false
  }
};

type cache = {
  npmPackages: Hashtbl.t(string, Yojson.Basic.json),
  opamPackages: Hashtbl.t(string, OpamParserTypes.opamfile),
  allBuildDeps: Hashtbl.t(string, list((realVersion, list(Lockfile.solvedDep)))),
  availableNpmVersions: Hashtbl.t(string, list((Types.triple, Yojson.Basic.json))),
  availableOpamVersions: Hashtbl.t(string, list((Types.triple, string))),
  manifests: Hashtbl.t((string, realVersion), (config, list(Types.dep), list(Types.dep))),
};

let viewRealVersion = v => switch v {
| `Github(s) => "github: " ++ s
| `Git(s) => "git: " ++ s
| `Npm(t) => "npm: " ++ Types.viewTriple(t)
| `Opam(t) => "opam: " ++ Types.viewTriple(t)
};

let toRealVersion = versionPlus => switch versionPlus {
| `Github(x) => `Github(x)
| `Npm(x, _) => `Npm(x)
| `Opam(x, _) => `Opam(x)
};

type state = {
  cache,
  universe: Cudf.universe,
  lookupRealVersion: Hashtbl.t((string, int), realVersion),
  lookupIntVersion: Hashtbl.t((string, realVersion), int),
};

let versionTicker = ref(0);

let nextVersion = () => {
  incr(versionTicker);
  versionTicker^
};

let getDeps = config => {
  let (deps, buildDeps, _) = switch config {
  | `OpamFile(opam) => OpamFile.process(opam)
  | `PackageJson(json) => PackageJson.process(json)
  };
  (deps, buildDeps)
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

let viewSource = source => switch source {
| Types.Npm(semver) => "npm: " ++ Types.viewSemver(semver)
| Opam(semver) => "opam: " ++ Types.viewSemver(semver)
| Github(s) => "github: " ++ s
| Git(s) => "git: " ++ s
};

let cudfDep = (state, (name, source)) => {
  let available = Cudf.lookup_packages(state.universe, name);
  let num = List.length(available);
  let available = available
  |> List.filter(matchesSource(source, state.lookupRealVersion))
  |> List.map(package => (package.Cudf.package, Some((`Eq, package.Cudf.version))));
  if (available == []) {
    print_endline("Opam semver wrong " ++ viewSource(source));
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
    |> List.filter(((version, json)) => NpmSemver.matches(version, semver))
    |> List.map(((version, json)) => `Npm(version, json));
  }

  | Opam(semver) => {
    if (!Hashtbl.mem(cache.availableOpamVersions, name)) {
      Hashtbl.replace(cache.availableOpamVersions, name, Registry.getFromOpamRegistry(name))
    };
    let available = Hashtbl.find(cache.availableOpamVersions, name);
    available
    |> List.filter(((version, path)) => NpmSemver.matches(version, semver))
    |> List.map(((version, path)) => `Opam(version, path));
  }
  | _ => []
  }
};

let getCachedManifest = (cache, (name, versionPlus)) => {
  let realVersion = toRealVersion(versionPlus);
  switch (Hashtbl.find(cache, (name, realVersion))) {
  | exception Not_found => {
    let manifest = switch versionPlus {
    | `Github(url) => Registry.getGithubManifest(url)
    | `Npm(version, json) => `PackageJson(json)
    | `Opam(version, path) => `OpamFile(OpamParser.file(path))
    };
    let (deps, buildDeps) = getDeps(manifest);
    let res = (manifest, deps, buildDeps);
    Hashtbl.replace(cache, (name, realVersion), res);
    res
  }
  | x => x
  };
};

let rec addPackage = (name, realVersion, deps, buildDeps, state, manifest) => {
  let version = nextVersion();
  /* print_endline("Adding a version for " ++ name ++ ": " ++ string_of_int(version)); */
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
      let (manifest, deps, buildDeps) = getCachedManifest(state.cache.manifests, (name, versionPlus));
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
      print_endline(p.Cudf.package ++ " @ " ++ viewRealVersion(version));
      let (manifest, _myDeps, myBuildDeps) = try(Hashtbl.find(state.cache.manifests, (p.Cudf.package, version))) {
      | Not_found => failwith("BAD NEWS no manifest for you")
      };
      ([{
        Lockfile.name: p.Cudf.package,
        version: viewRealVersion(version),
        archive: "",
        checksum: "",
        unpackedLocation: "",
        buildDeps: [],
      }, ...deps], myBuildDeps @ buildDeps)
    }, ([], []))
  }
  };
}

and processBuildDeps = (cache, deps) => {
  let unmetDeps = deps |> List.filter(((name, req)) => {
    switch (Hashtbl.find(cache.allBuildDeps, name)) {
    | exception Not_found => true
    | items => !List.exists(((version, _)) => satisfies(version, req), items)
    }
  });
  let toInstall = unmetDeps |> List.map(((name, req)) => {
    let available = getAvailableVersions(cache, (name, req));
    (name, List.find(version => satisfies(toRealVersion(version), req), available));
  }) |> List.sort_uniq(compare);
  failwith("Not impl");
};

let solve = (config) => {
  let cache = {
    npmPackages: Hashtbl.create(100),
    opamPackages: Hashtbl.create(100),
    allBuildDeps: Hashtbl.create(100),
    availableNpmVersions: Hashtbl.create(100),
    availableOpamVersions: Hashtbl.create(100),
    manifests: Hashtbl.create(100),
  };

  let (deps, buildDeps, _devDeps) = switch config {
  | `OpamFile(file) => OpamFile.process(file)
  | `PackageJson(json) => PackageJson.process(json)
  };

  let (solvedDeps, collectedBuildDeps) = solveDeps(cache, deps);

  print_endline("Now dev deps");
  let _ = processBuildDeps(cache, collectedBuildDeps);

  let _lockfile = {
    ...Lockfile.empty,
    requestedDeps: deps,
    requestedBuildDeps: buildDeps,
    solvedDeps
  };
  print_endline("Dones")
};
