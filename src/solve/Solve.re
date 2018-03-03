open Opam;
open Npm;
open Shared;

open SolveUtils;
open SolveDeps.T;

let rec processBuildDeps = (cache, deps) => {
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

  /* print_endline("Chose these dev deps"); */
  let allBuildDeps = toInstall |> List.map(((name, versionPlus)) => {
    /* print_endline(name ++ ": " ++ Lockfile.viewRealVersion(toRealVersion(versionPlus))); */
    let (manifest, deps, buildDeps) = getCachedManifest(cache.opamOverrides, cache.manifests, (name, versionPlus));
    let (solvedDeps, collectedBuildDeps) = SolveDeps.solveDeps(cache, deps);

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

  let (solvedDeps, collectedBuildDeps) = SolveDeps.solveDeps(cache, deps);

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
