
open Shared;
open Opam;

let (/+) = Filename.concat;

let resolvedString = (name, version) => Types.resolvedPrefix ++ name ++ "--" ++ Lockfile.viewRealVersion(version);

let addResolvedFieldToPackageJson = (filename, name, version) => {
  let json = switch (Yojson.Basic.from_file(filename)) {
  | `Assoc(items) => items
  | _ => failwith("bad json")
  };
  let raw = Yojson.Basic.pretty_to_string(`Assoc([("_resolved", `String(resolvedString(name, version))), ...json]));
  Files.writeFile(filename, raw) |> Files.expectSuccess("Could not write back package json");
};

let absname = (name, version) => {
  name ++ "__" ++ Lockfile.viewRealVersion(version)
};

/**
 * Unpack an archive into place, and then for opam projects create a package.json & apply files / patches.
 */
let unpackArchive = (dest, cache, {Lockfile.name, version, opamFile, source}) => {
  if (Files.isDirectory(dest)) {
    print_endline("Dependency exists -- assuming it is fine " ++ dest)
  } else {
    Files.mkdirp(dest);

    switch source {
    | Types.Source.Archive(url, _checksum) => {
      let safe = Str.global_replace(Str.regexp("/"), "-", name);
      let withVersion = safe ++ Lockfile.viewRealVersion(version);
      let tarball = cache /+ withVersion ++ ".tarball";
      if (!Files.isFile(tarball)) {
        ExecCommand.execSync(~cmd="curl -L --output "++ tarball ++ " " ++ url, ()) |> snd |> Files.expectSuccess("failed to fetch with curl");
      };
      ExecCommand.execSync(~cmd="tar xf " ++ tarball ++ " --strip-components 1 -C " ++ dest, ()) |> snd |> Files.expectSuccess("failed to untar");
    }
    | Types.Source.NoSource => ()
    | Types.Source.GithubSource(user, repo, ref) => {
      let safe = Str.global_replace(Str.regexp("/"), "-", name ++ "__" ++ user ++ "__" ++ repo ++ "__" ++ ref);
      let tarball = cache /+ safe ++ ".tarball";
      if (!Files.isFile(tarball)) {
        let tarUrl = "https://api.github.com/repos/" ++ user ++ "/" ++ repo ++ "/tarball/" ++ ref;
        ExecCommand.execSync(~cmd="curl -L --output "++ tarball ++ " " ++ tarUrl, ()) |> snd |> Files.expectSuccess("failed to fetch with curl");
      };
      ExecCommand.execSync(~cmd="tar xf " ++ tarball ++ " --strip-components 1 -C " ++ dest, ()) |> snd |> Files.expectSuccess("failed to untar");
    }
    | Types.Source.GitSource(gitUrl, commit) => {
      let safe = Str.global_replace(Str.regexp("/"), "-", name);
      let withVersion = safe ++ Lockfile.viewRealVersion(version);
      let tarball = cache /+ withVersion ++ ".tarball";
      if (!Files.isFile(tarball)) {
        print_endline("[fetching git repo " ++ gitUrl ++ " at commit " ++ commit);
        let gitdest = cache /+ "git-" ++ withVersion;
        /** TODO we want to have the commit nailed down by this point tho */
        ExecCommand.execSync(~cmd="git clone " ++ gitUrl ++ " " ++ gitdest, ()) |> snd |> Files.expectSuccess("Unable to clone git repo " ++ gitUrl);
        ExecCommand.execSync(~cmd="cd " ++ gitdest ++ " && git checkout " ++ commit ++ " && rm -rf .git", ()) |> snd |> Files.expectSuccess("Unable to checkout " ++ gitUrl ++ " at " ++ commit);
        ExecCommand.execSync(~cmd="tar czf " ++ tarball ++ " " ++ gitdest, ()) |> snd |> Files.expectSuccess("Unable to tar up");
        ExecCommand.execSync(~cmd="mv " ++ gitdest ++ " " ++ dest, ()) |> snd |> Files.expectSuccess("Unable to move");
      } else {
        ExecCommand.execSync(~cmd="tar xf " ++ tarball ++ " --strip-components 1 -C " ++ dest, ()) |> snd |> Files.expectSuccess("failed to untar");
      }
    }
    };

    let packageJson = dest /+ "package.json";
    switch opamFile {
    | None => {
      if (!Files.exists(packageJson)) {
        failwith("No opam file or package.json");
      };
      addResolvedFieldToPackageJson(packageJson, name, version);
    }
    | Some((packageJson, files, patches)) => {
      if (Files.exists(dest /+ "esy.json")) {
        Unix.unlink(dest /+ "esy.json");
      };
      let raw = Yojson.Basic.pretty_to_string(Yojson.Safe.to_basic(packageJson));
      Files.writeFile(dest /+ "package.json", raw) |> Files.expectSuccess("could not write package.json");
      files |> List.iter(((relpath, contents)) => {
        Files.mkdirp(Filename.dirname(dest /+ relpath));
        Files.writeFile(dest /+ relpath, contents) |> Files.expectSuccess("could not write file " ++ relpath)
      });

      patches |> List.iter((abspath) => {
        ExecCommand.execSync(
          ~cmd=Printf.sprintf("sh -c 'cd %s && patch -p1 < %s'", dest, abspath),
          ()
        ) |> snd |> Files.expectSuccess("Failed to patch")
      });
    }
    }
  }
};

/* Get a package and its children & build deps */
let rec fetchDep = (modcache, cache, {Lockfile.name, version} as dep, childDeps) => {
  let base = modcache /+ absname(name, version);
  if (Files.exists(base)) {
    ()
  } else {
    unpackArchive(base, cache, dep);

    childDeps |> List.iter((childDep) => {
      let dest = base /+ "node_modules" /+ childDep.Shared.Lockfile.name;
      if (Files.exists(dest)) {
        print_endline("Dev dep conflicting with a normal dep -- this isn't handled correctly by esy b yet " ++ dest);
      } else {
        fetchDep(modcache, cache, childDep, []);
        Files.mkdirp(Filename.dirname(dest));
        Files.symlink(modcache /+ absname(childDep.name, childDep.version), dest)
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
    })
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
    fetchDep(modcache, cache, dep, []);

    let dest = basedir /+ "node_modules" /+ dep.name;
    Files.mkdirp(Filename.dirname(dest));
    Files.symlink(modcache /+ absname(dep.name, dep.version), dest);
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
        fetchDep(modcache, cache, dep, childDeps);
    }
    | _ => failwith("Can't handle multiple versions just yet")
    }
  })
};