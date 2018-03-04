open Opam;
open Npm;
open Shared;

open SolveUtils;
open SolveDeps.T;

/*
 * This file solves deps + buildDeps
 *
 * but doesn't do buildDeps very well, actually
 *
 * might as well just not do them for the moment.
 * Count everything as a normal dep.
 */

let solveDepsWithBuildDeps = (cache, deps) => {
  SolveDeps.solveDeps(cache, deps)
      |> List.fold_left(((deps, buildDeps), (name, version, manifest, requestedDeps, requestedBuildDeps)) => {

      ([{
          Lockfile.name: name,
          version: version,
          requestedDeps,
          requestedBuildDeps,
          source: lockDownSource(switch version {
          | `Github(user, repo, ref) => Types.PendingSource.GithubSource(user, repo, ref)
          | _ => Manifest.getArchive(manifest)}) ,
          opamFile: getOpamFile(manifest, cache.opamOverrides, name, version),
          unpackedLocation: "",
          buildDeps: [],
        }
        , ...deps], requestedBuildDeps @ buildDeps)
      }, ([], []))
};

let rec processBuildDeps = (allBuildDepsCache, cache, deps) => {
  let unmetDeps = deps |> List.filter(((name, req)) => {
    switch (Hashtbl.find(allBuildDepsCache, name)) {
    | exception Not_found => true
    | items => !List.exists(((version, _, _)) => satisfies(version, req), items)
    }
  });
  let toInstall = unmetDeps |> List.map(((name, req)) => {
    let available = VersionCache.getAvailableVersions(cache.versions, (name, req));
    let work = List.find_all(version => satisfies(toRealVersion(version), req), available);
    if (work == []) {
      failwith("No working versions found for " ++ name ++ " " ++ Shared.Types.viewReq(req));
    };
    let got = work |> List.sort((a, b) => sortRealVersions(toRealVersion(b), toRealVersion(a))) |> List.hd;
    (name, got);
  }) |> List.sort_uniq(compare);

  let allBuildDeps = toInstall |> List.map(((name, versionPlus)) => {
    let (manifest, deps, buildDeps) = getCachedManifest(cache.opamOverrides, cache.manifests, (name, versionPlus));
    let (solvedDeps, collectedBuildDeps) = solveDepsWithBuildDeps(cache, deps);

    let current = switch (Hashtbl.find(allBuildDepsCache, name)) {
    | exception Not_found => []
    | items => items
    };
    Hashtbl.replace(allBuildDepsCache, name, [
      (toRealVersion(versionPlus), solvedDeps, buildDeps),
      ...current
    ]);

    buildDeps @ collectedBuildDeps
  }) |> List.concat;
  if (allBuildDeps != []) {
    processBuildDeps(allBuildDepsCache, cache, allBuildDeps)
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

let addBuildDepsForSolvedDep = (allBuildDepsCache, cache, solvedDep) => {
  let key = (solvedDep.Lockfile.name, solvedDep.Lockfile.version);
  let (_, _, buildDeps) = switch (Hashtbl.find(cache.manifests, key)) {
  | exception Not_found => failwith("No manifest during final resolution")
  | x => x
  };

  {
    ...solvedDep,
    Lockfile.buildDeps: List.map(resolveBuildDep(allBuildDepsCache), buildDeps)
  }
};

let checkRepositories = config => {
  ensureGitRepo("https://github.com/esy-ocaml/esy-opam-override", config.Shared.Types.esyOpamOverrides);
  ensureGitRepo("https://github.com/ocaml/opam-repository", config.Shared.Types.opamRepository);
};

let solve = (config, manifest) => {
  checkRepositories(config);
  let cache = SolveDeps.initCache(config);

  let (deps, buildDeps, devDeps) = switch manifest {
  | `OpamFile(file) => OpamFile.process(file)
  | `PackageJson(json) => PackageJson.process(json)
  };
  let buildDeps = buildDeps @ devDeps;

  let (solvedDeps, collectedBuildDeps) = solveDepsWithBuildDeps(cache, deps);
  let allBuildDepsCache = Hashtbl.create(100);

  print_endline("Now dev deps");
  processBuildDeps(allBuildDepsCache, cache, buildDeps @ collectedBuildDeps);

  let allBuildDeps = Hashtbl.fold(
    (key, items, res) => [(key,
      items |> List.map(((realVersion, solvedDeps, buildDeps)) => {
        let (manifest, _myDeps, myBuildDeps) = Hashtbl.find(cache.manifests, (key, realVersion));
        let (requestedDeps, requestedBuildDeps) = Manifest.getDeps(manifest);
        ({
          Lockfile.name: key,
          source: lockDownSource(Manifest.getArchive(manifest)),
          opamFile: getOpamFile(manifest, cache.opamOverrides, key, realVersion),
          version: realVersion,
          unpackedLocation: "",
          requestedDeps,
          requestedBuildDeps,
          buildDeps: List.map(resolveBuildDep(allBuildDepsCache), buildDeps)
        }, List.map(addBuildDepsForSolvedDep(allBuildDepsCache, cache), solvedDeps),)
    })
    ), ...res],
    allBuildDepsCache,
    []
  );

  {
    Lockfile.requestedDeps: deps,
    requestedBuildDeps: buildDeps,
    allBuildDeps,
    solvedDeps: List.map(addBuildDepsForSolvedDep(allBuildDepsCache, cache), solvedDeps),
    solvedBuildDeps: List.map(resolveBuildDep(allBuildDepsCache), buildDeps)
  };
};
