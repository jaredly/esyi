open Opam;
open Npm;
open Shared;

type manifest = [
  | `OpamFile(OpamFile.manifest)
  | `PackageJson(Yojson.Basic.json)
];

Printexc.record_backtrace(true);

let satisfies = (realVersion, req) => {
  switch (req, realVersion) {
  | (Types.Github(user, repo, ref), `Github(user_, repo_, ref_)) when user == user_ && repo == repo_ && ref == ref_ => true
  | (Npm(semver), `Npm(s)) when NpmVersion.matches(semver, s) => true
  | (Opam(semver), `Opam(s)) when OpamVersion.matches(semver, s) => true
  | _ => false
  }
};

let sortRealVersions = (a, b) => {
  switch (a, b) {
  | (`Github(a), `Github(b)) => 0
  | (`Npm(a), `Npm(b)) => NpmVersion.compare(a, b)
  | (`Opam(a), `Opam(b)) => OpamVersion.compare(a, b)
  | _ => 0
  }
};

type cache = {
  config: Types.config,
  opamOverrides: list((string, Types.opamRange, string)),
  npmPackages: Hashtbl.t(string, Yojson.Basic.json),
  opamPackages: Hashtbl.t(string, OpamFile.manifest),
  allBuildDeps: Hashtbl.t(string, list((Lockfile.realVersion, list(Lockfile.solvedDep), list(Types.dep)))),
  availableNpmVersions: Hashtbl.t(string, list((Types.npmConcrete, Yojson.Basic.json))),
  availableOpamVersions: Hashtbl.t(string, list((Types.opamConcrete, OpamFile.thinManifest))),
  manifests: Hashtbl.t((string, Lockfile.realVersion), (manifest, list(Types.dep), list(Types.dep))),
};

let toRealVersion = versionPlus => switch versionPlus {
| `Github(x) => `Github(x)
| `Npm(x, _, _) => `Npm(x)
| `Opam(x, _, _) => `Opam(x)
};

type state = {
  cache,
  universe: Cudf.universe,
  lookupRealVersion: Hashtbl.t((string, int), Lockfile.realVersion),
  lookupIntVersion: Hashtbl.t((string, Lockfile.realVersion), int),
};

let versionTicker = ref(100000);

let nextVersion = () => {
  incr(versionTicker);
  versionTicker^
};

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

/* [@test [
  ((Npm.OpamConcrete.parseConcrete("1.2.0")))
]]
let opamMatchesIfYourePretendingToBeNpm = (fakeNpmVersion, opamVersion) => {
  open Types;
  let rec alpha = (Alpha(n_str, n_num), Alpha(o_str, o_num)) => {

  } and num = (Num(n_num, n_str), Num(o_num, o_str)) => {

  };
  true
}; */

/** TODO(jared): This is a HACK and will hopefully be removed once we stop the
 * pseudo-npm opam version stuff */
let rec tryConvertingOpamFromNpm = version => {
  open Shared.Types;
  version |> Shared.GenericVersion.map(opam => {
    /* try stripping the patch version */
    /* print_endline("in the guts " ++ Shared.Types.viewOpamConcrete(opam)); */
    switch opam {
    /* yay jbuilder */
    | Alpha("", Some(Num(major, Some(Alpha(".", Some(Num(minor, Some(Alpha(".", Some(Num(0, Some(Alpha("-beta", rest))))))))))))) => {
      Alpha("", Some(Num(major, Some(Alpha(".", Some(Num(minor, Some(Alpha("+beta", rest)))))))))
    }
    | Alpha("", Some(Num(major, Some(Alpha(".", Some(Num(minor, Some(Alpha(".", Some(Num(0, post))))))))))) => {
      Alpha("", Some(Num(major, Some(Alpha(".", Some(Num(minor, post)))))))
    }
    | _ => opam
    }
  });
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
      if (name == "ocaml") {
        /* We know there are packages that want versions of ocaml we don't support, it's ok */
        []
      } else {
        print_endline("🛑 🛑 🛑  Requirement unsatisfiable " ++ owner ++ " wants " ++ name ++ " at version " ++ Types.viewReq(source));
        available |> List.iter(package => print_endline("  - " ++ Lockfile.viewRealVersion(getRealVersion(state.lookupRealVersion, package))));
        []
      }
      /* failwith("No package found for " ++ name ++ " when converting to a cudf dep (found " ++ string_of_int(num) ++ " incompatible versions)") */
    }
    | matching => matching
    }
  } else {
    matching
  })
  |> List.map(package => (package.Cudf.package, Some((`Eq, package.Cudf.version))));
  /** If no matching packages, make a requirement for a package that doesn't exist. */
  final == [] ? [(List.hd(available).Cudf.package, Some((`Eq, 10000000000)))] : final
};

let getAvailableVersions = (cache, (name, source)) => {
  switch source {
  | Types.Github(user, repo, ref) => {
    [`Github(user, repo, ref)]
  }
  | Npm(semver) => {
    if (!Hashtbl.mem(cache.availableNpmVersions, name)) {
      Hashtbl.replace(cache.availableNpmVersions, name, Npm.Registry.getFromNpmRegistry(name));
    };
    let available = Hashtbl.find(cache.availableNpmVersions, name);
    available
    |> List.sort(((va, _), (vb, _)) => NpmVersion.compare(va, vb))
    |> List.mapi((i, (v, j)) => (v, j, i))
    |> List.filter(((version, json, i)) => NpmVersion.matches(semver, version))
    |> List.map(((version, json, i)) => `Npm(version, json, i));
  }

  | Opam(semver) => {
    if (!Hashtbl.mem(cache.availableOpamVersions, name)) {
      Hashtbl.replace(cache.availableOpamVersions, name, Opam.Registry.getFromOpamRegistry(cache.config, name))
    };
    let available = Hashtbl.find(cache.availableOpamVersions, name)
    |> List.sort(((va, _), (vb, _)) => OpamVersion.compare(va, vb))
    |> List.mapi((i, (v, j)) => (v, j, i));
    let matched = available
    |> List.filter(((version, path, i)) => OpamVersion.matches(semver, version));
    let matched = if (matched == []) {
      /* print_endline("No matching versions for " ++ name ++ " when looking in the opam repo");
      List.iter(((version, _, _)) => print_endline(Types.viewOpamConcrete(version)), available); */
      available |> List.filter(((version, path, i)) => OpamVersion.matches(tryConvertingOpamFromNpm(semver), version))
    } else {
      matched
    };
    matched |> List.map(((version, path, i)) => `Opam(version, path, i));
  }
  | _ => []
  }
};

let getCachedManifest = (opamOverrides, cache, (name, versionPlus)) => {
  let realVersion = toRealVersion(versionPlus);
  switch (Hashtbl.find(cache, (name, realVersion))) {
  | exception Not_found => {
    let manifest = switch versionPlus {
    | `Github(user, repo, ref) => Github.getManifest(name, user, repo, ref)
    /* Registry.getGithubManifest(url) */
    | `Npm(version, json, _) => `PackageJson(json)
    | `Opam(version, path, _) => `OpamFile(OpamFile.getManifest(opamOverrides, path))
    };
    let (deps, buildDeps) = Manifest.getDeps(manifest);
    let res = (manifest, deps, buildDeps);
    Hashtbl.replace(cache, (name, realVersion), res);
    res
  }
  | x => x
  };
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
  getAvailableVersions(state.cache, (name, source)) |> List.iter(versionPlus => {
    let (realVersion, i) = switch versionPlus {
    | `Github(v) => (`Github(v), nextVersion())
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

let rootPackage = (deps, state) => {
  {
    ...Cudf.default_package,
    package: rootName,
    version: 1,
    depends: List.map(cudfDep("root", state), deps)
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

let lockDownSource = pendingSource => switch pendingSource {
| Types.PendingSource.NoSource => Types.Source.NoSource
| Archive(url, None) => {
  print_endline("Pretending to get a checksum for " ++ url);
  Types.Source.Archive(url, "fake checksum")
}
| Archive(url, Some(checksum)) => Types.Source.Archive(url, checksum)
| GitSource(url, None) => {
  /** TODO getting HEAD */
  "git ls-remote git://github.com/alainfrisch/ppx_tools.git HEAD";
  Types.Source.GitSource(url, "HEAD")
}
| GitSource(url, Some(sha)) => Types.Source.GitSource(url, sha)
| GithubSource(user, name, ref) => Shared.Infix.(Types.Source.GithubSource(user, name, ref |? "master"))
};

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
    print_endline("adding everyrthing to the universe");
    List.iter(addToUniverse(state), deps);

    let request = makeRequest(deps, state);
    let preamble = Cudf.default_preamble;
    print_endline("Running the SMT solver");
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
        let (requestedDeps, requestedBuildDeps) = Manifest.getDeps(manifest);
        ([{
          Lockfile.name: p.Cudf.package,
          version: version,
          requestedDeps,
          requestedBuildDeps,
          source: lockDownSource(switch version {
          | `Github(user, repo, ref) => Types.PendingSource.GithubSource(user, repo, ref)
          | _ => Manifest.getArchive(manifest)}) ,
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
    print_endline(name);
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
        let (requestedDeps, requestedBuildDeps) = Manifest.getDeps(manifest);
        ({
          Lockfile.name: key,
          source: lockDownSource(Manifest.getArchive(manifest)),
          opamFile: getOpamFile(manifest),
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

    /* ...Lockfile.empty, */
  {
    Lockfile.requestedDeps: deps,
    requestedBuildDeps: buildDeps,
    allBuildDeps,
    solvedDeps: List.map(addBuildDepsForSolvedDep(cache), solvedDeps),
    solvedBuildDeps: List.map(resolveBuildDep(cache.allBuildDeps), buildDeps)
  };
};
