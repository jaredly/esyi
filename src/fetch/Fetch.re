
open Shared;
open Opam;

let (/+) = Filename.concat;

let consume = (fn, opt) => switch opt { | None => () | Some(x) => fn(x)};

let expectSuccess = (msg, v) => if (v) { () } else { failwith(msg) };

let relpath = (base, path) => {
  /**
   * /a/b/c/
   * /a/b/d/
   * ../d
   *
   * /a/b/c/
   * /a/b/d/e/
   * ../d/e
   *
   * /a/b/c/
   * /d/e/f/
   * ../../../d/e/f
   *
   * /a/b/c/
   * /a/b/c/d/e/
   * ./d/e/
   */
  let rec loop = (bp, pp) => {
    switch (bp, pp) {
    | ([a, ...ra], [b, ...rb]) when a == b => loop(ra, rb)
    | _ => (bp, pp)
    }
  };
  let (base, path) = loop(String.split_on_char('/', base), String.split_on_char('/', path));
  String.concat("/",
  List.map((_) => "..", base) @ path
  )
};

let symlink = (source, dest) => {
  Unix.symlink(relpath(Filename.dirname(dest), source), dest)
};

let addResolvedFieldToPackageJson = (filename, name, version) => {
  let json = switch (Yojson.Basic.from_file(filename)) {
  | `Assoc(items) => items
  | _ => failwith("bad json")
  };
  let raw = Yojson.Basic.pretty_to_string(`Assoc([
    ("_resolved", `String(Types.resolvedPrefix ++ name ++ "--" ++ Lockfile.viewRealVersion(version))),
    ...json
  ]));
  Files.writeFile(filename, raw) |> expectSuccess("Could not write back package json");
  /** TODO */
  ()
};

let absname = (name, version) => {
  name ++ "__" ++ Lockfile.viewRealVersion(version)
};

let unpackArchive = (opamOverrides, dest, cache, {Lockfile.name, version, opamFile, source}) => {
  if (Files.isDirectory(dest)) {
    print_endline("Dependency exists -- assuming it is fine " ++ dest)
    /* failwith("Dependency directory already exists: " ++ dest) */
  } else {
    Files.mkdirp(dest);

    source |> consume(((url, _checksum)) => {
      let safe = Str.global_replace(Str.regexp("/"), "-", name);
      let withVersion = safe ++ Lockfile.viewRealVersion(version);
      let tarball = cache /+ withVersion ++ ".tarball";
      if (!Files.isFile(tarball)) {
        ExecCommand.execSync(~cmd="curl -L --output "++ tarball ++ " " ++ url, ()) |> snd |> expectSuccess("failed to fetch with curl");
      };
      ExecCommand.execSync(~cmd="tar xf " ++ tarball ++ " --strip-components 1 -C " ++ dest, ()) |> snd |> expectSuccess("failed to untar");
    });

    /* print_endline("Checking " ++ dest /+ "package.json"); */
    let packageJson = dest /+ "package.json";
    switch opamFile {
    | None => {
      if (!Files.exists(packageJson)) {
        failwith("No opam file or package.json");
      };
      addResolvedFieldToPackageJson(packageJson, name, version);
    }
    | Some(opamFile) => {
      if (Files.exists(dest /+ "esy.json")) {
        Unix.unlink(dest /+ "esy.json");
      };
      let (packageJson, files, patches) = OpamFile.toPackageJson(opamOverrides, opamFile, name, version);
      let raw = Yojson.Basic.pretty_to_string(packageJson);
      Files.writeFile(dest /+ "package.json", raw) |> expectSuccess("could not write package.json");
      files |> List.iter(((relpath, contents)) => {
        Files.mkdirp(Filename.dirname(dest /+ relpath));
        Files.writeFile(dest /+ relpath, contents) |> expectSuccess("could not write file " ++ relpath)
      });

      patches |> List.iter((abspath) => {
        ExecCommand.execSync(
          ~cmd=Printf.sprintf("sh -c 'cd %s && patch -p1 < %s'", dest, abspath),
          ()
        ) |> snd |> expectSuccess("Failed to patch")
      });

      /* Yojson.Basic.to_file(dest /+ "package.json", packageJson); */
      /* print_endline("Wrote package.json out " ++ dest /+ "package.json") */
    }
    }
  }
};

let rec fetchDep = (opamOverrides, modcache, cache, {Lockfile.name, version} as dep, childDeps) => {
  let base = modcache /+ absname(name, version);
  if (Files.exists(base)) {
    /* print_endline("Found " ++ base ++ " assuming its fine"); */
    ()
  } else {
    unpackArchive(opamOverrides, base, cache, dep);

    childDeps |> List.iter((childDep) => {
      fetchDep(opamOverrides, modcache, cache, childDep, []);

      let dest = base /+ "node_modules" /+ childDep.name;
      if (Files.exists(dest)) {
        failwith("Dev dep conflicting with a normal dep -- this isn't handled correctly by esy b yet " ++ dest);
      };
      Files.mkdirp(Filename.dirname(dest));
      symlink(modcache /+ absname(childDep.name, childDep.version), dest)
    });

    dep.buildDeps |> List.iter(((name, realVersion)) => {
      print_endline("Dev dep here " ++ absname(name, realVersion));
      let dest = base /+ "node_modules" /+ name;
      if (Files.exists(dest)) {
        failwith("Dev dep conflicting with a normal dep -- this isn't handled correctly by esy b yet " ++ dest);
      };
      Files.mkdirp(Filename.dirname(dest));
      symlink(modcache /+ absname(name, realVersion), dest)
    })
  }
};

let fetch = (config, basedir, lockfile) => {
  let opamOverrides = Opam.OpamOverrides.getOverrides(config.Types.esyOpamOverrides);
  let cache = basedir /+ ".esy-cache" /+ "archives";
  Files.mkdirp(cache);

  open Lockfile;

  let modcache = basedir /+ ".esy-modules";

  Files.mkdirp(basedir /+ "node_modules");
  lockfile.solvedDeps |> List.iter((dep) => {
    fetchDep(opamOverrides, modcache, cache, dep, []);

    let dest = basedir /+ "node_modules" /+ dep.name;
    Files.mkdirp(Filename.dirname(dest));
    symlink(modcache /+ absname(dep.name, dep.version), dest);
  });

  lockfile.solvedBuildDeps |> List.iter(((name, realVersion)) => {
    print_endline("Dev dep here " ++ absname(name, realVersion));
    let dest = basedir /+ "node_modules" /+ name;
    if (Files.exists(dest)) {
      failwith("Dev dep conflicting with a normal dep -- this isn't handled correctly by esy b yet " ++ dest);
    };
    Files.mkdirp(Filename.dirname(dest));
    symlink(modcache /+ absname(name, realVersion), dest)
  });

  lockfile.allBuildDeps |> List.iter(((name, versions)) => {
    switch versions {
    | [(dep, childDeps)] => {
        fetchDep(opamOverrides, modcache, cache, dep, childDeps);
    }
    | _ => failwith("Can't handle multiple versions just yet")
    }
  })
};