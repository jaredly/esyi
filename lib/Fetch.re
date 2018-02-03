
let (/+) = Filename.concat;

let consume = (fn, opt) => switch opt { | None => () | Some(x) => fn(x)};

let unpackArchive = (opamOverrides, basedir, cache, {Lockfile.name, version, opamFile}, source) => {
  let dest = basedir /+ "node_modules" /+ name;
  Files.mkdirp(dest);

  source |> consume(((url, _checksum)) => {
    let safe = Str.global_replace(Str.regexp("/"), "-", name);
    let withVersion = safe ++ Lockfile.viewRealVersion(version);
    let tarball = cache /+ withVersion ++ ".tarball";
    if (!Files.isFile(tarball)) {
      ExecCommand.execSync(~cmd="curl -L --output "++ tarball ++ " " ++ url, ()) |> ignore;
    };
    ExecCommand.execSync(~cmd="tar xf " ++ tarball ++ " --strip-components 1 -C " ++ dest, ()) |> ignore;
  });

  print_endline("Checking " ++ dest /+ "package.json");
  let packageJson = dest /+ "package.json";
  switch opamFile {
  | None => {
    if (!Files.exists(packageJson)) {
      failwith("No opam file or package.json");
    }
  }
  | Some(opamFile) => {
    if (Files.exists(dest /+ "esy.json")) {
      Unix.unlink(dest  /+ "esy.json");
    };
    let packageJson = OpamFile.toPackageJson(opamOverrides, opamFile, name, version);
    Yojson.Basic.to_file(dest /+ "package.json", packageJson);
    print_endline("Wrote package.json out " ++ dest /+ "package.json")
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