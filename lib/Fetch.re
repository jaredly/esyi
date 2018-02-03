
let (/+) = Filename.concat;

let consume = (fn, opt) => switch opt { | None => () | Some(x) => fn(x)};

let expectSuccess = (msg, v) => if (v) { () } else { failwith(msg) };

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

let unpackArchive = (opamOverrides, basedir, cache, {Lockfile.name, version, opamFile}, source) => {
  let dest = basedir /+ "node_modules" /+ name;
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
};

let fetch = (config, basedir, lockfile) => {
  let opamOverrides = OpamOverrides.getOverrides(config.Types.esyOpamOverrides);
  let cache = basedir /+ ".esy-cache" /+ "archives";
  Files.mkdirp(cache);

  open Lockfile;

  lockfile.solvedDeps |> List.iter(({source} as dep) => {
    unpackArchive(opamOverrides, basedir, cache, dep, source);
  });

  lockfile.allBuildDeps |> List.iter(((name, versions)) => {
    switch versions {
    | [({source} as dep, childDeps)] => {
        unpackArchive(opamOverrides, basedir, cache, dep, source);
        childDeps |> List.iter(({source} as childDep) => {
          unpackArchive(opamOverrides, basedir /+ "node_modules" /+ name, cache, childDep, source)
        });
    }
    | _ => failwith("Can't handle multiple versions just yet")
    }
  })
};