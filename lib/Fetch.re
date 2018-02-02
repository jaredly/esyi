
let (/+) = Filename.concat;

let consume = (fn, opt) => switch opt { | None => () | Some(x) => fn(x)};

let unpackArchive = (basedir, cache, {Lockfile.name, version, opamFile}, archive) => {
  let dest = basedir /+ "node_modules" /+ name;
  Files.mkdirp(dest);

  archive |> consume(url => {
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
    let packageJson = OpamFile.toPackageJson(opamFile, name, version);
    Yojson.Basic.to_file(dest /+ "package.json", packageJson);
    print_endline("Wrote package.json out " ++ dest /+ "package.json")
  }
  }
};

let fetch = (basedir, lockfile) => {
  let cache = basedir /+ ".esy-cache" /+ "archives";
  Files.mkdirp(cache);

  open Lockfile;

  lockfile.solvedDeps |> List.iter(({archive} as dep) => {
    unpackArchive(basedir, cache, dep, archive);
  });

  lockfile.allBuildDeps |> List.iter(((name, versions)) => {
    switch versions {
    | [({archive} as dep, childDeps)] => {
        unpackArchive(basedir, cache, dep, archive);
        childDeps |> List.iter(({archive} as childDep) => {
          unpackArchive(basedir /+ "node_modules" /+ name, cache, childDep, archive)
        });
    }
    | _ => failwith("Can't handle multiple versions just yet")
    }
  })
};