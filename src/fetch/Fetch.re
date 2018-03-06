
open Shared;
open Opam;
open FetchUtils;

let (/+) = Filename.concat;

/* Get a package and its children & build deps */
let rec fetchDep = (modcache, cache, {Lockfile.SolvedDep.name, version, source} as dep, childDeps) => {
  let base = modcache /+ absname(name, version);
  if (Files.exists(base)) {
    base
  } else {
    unpackArchive(base, cache, name, version, source);

    childDeps |> List.iter((childDep) => {
      let dest = base /+ "node_modules" /+ childDep.Shared.Lockfile.SolvedDep.name;
      if (Files.exists(dest)) {
        print_endline("Dev dep conflicting with a normal dep -- this isn't handled correctly by esy b yet " ++ dest);
      } else {
        let childDest = fetchDep(modcache, cache, childDep, []);
        Files.mkdirp(Filename.dirname(dest));
        Files.symlink(childDest, dest)
      }
    });

    dep.buildDeps |> List.iter(((name, realVersion)) => {
      print_endline("Dev dep here " ++ absname(name, realVersion));
      let dest = base /+ "node_modules" /+ name;
      if (Files.exists(dest)) {
        failwith("Dev dep conflicting with a normal dep -- this isn't handled correctly by esy b yet " ++ dest);
      };
      Files.mkdirp(Filename.dirname(dest));
      Files.symlink(modcache /+ absname(name, realVersion), dest)
    });

    base
  }
};

/* Do the whole fetching! */
let fetch = (basedir, lockfile) => {
  let cache = basedir /+ ".esy-cache" /+ "archives";
  Files.mkdirp(cache);

  open Lockfile;

  let modcache = basedir /+ ".esy-modules";

  Files.mkdirp(basedir /+ "node_modules");
  lockfile.solvedDeps |> List.iter((dep) => {
    let unpackedLocation = fetchDep(modcache, cache, dep, []);

    let dest = basedir /+ "node_modules" /+ dep.name;
    Files.mkdirp(Filename.dirname(dest));
    Files.symlink(unpackedLocation, dest);
  });

  lockfile.solvedBuildDeps |> List.iter(((name, realVersion)) => {
    print_endline("Dev dep here " ++ absname(name, realVersion));
    let dest = basedir /+ "node_modules" /+ name;
    if (Files.exists(dest)) {
      /** TODO handle better */
      print_endline("Dev dep conflicting with a normal dep -- this isn't handled correctly by esy b yet " ++ dest);
    } else {
      Files.mkdirp(Filename.dirname(dest));
      Files.symlink(modcache /+ absname(name, realVersion), dest)
    }
  });

  lockfile.allBuildDeps |> List.iter(((name, versions)) => {
    switch versions {
    | [(dep, childDeps)] => {
        let _unpacked = fetchDep(modcache, cache, dep, childDeps);
    }
    | _ => failwith("Can't handle multiple versions just yet")
    }
  })
};

let fetchNew = FetchNew.fetch;