let (/+) = Filename.concat;

let homeDir = () => {
  let uid = Unix.getuid();
  let home = Unix.getpwuid(uid).Unix.pw_dir;
  /* TODO: fallback to $HOME here */
  /* TODO: make it return resul (string, _) instead */
  home;
};

let solve = (basedir) => {
  let homeDir = homeDir();
  let json = Yojson.Basic.from_file(basedir /+ "package.json");
  let lockfile = Solve.solve({
    Shared.Types.esyOpamOverrides: homeDir /+ ".esyi/esy-opam-override",
    opamRepository: homeDir /+ ".esyi/opam-repository"
  }, `PackageJson(json));
  let json = Shared.Lockfile.lockfile_to_yojson(lockfile);
  let chan = open_out(basedir /+ "esyi.lock.json");
  Yojson.Safe.pretty_to_channel(chan, json);
  close_out(chan);
};

let fetch = (basedir) => {
  let json = Yojson.Safe.from_file(basedir /+ "esyi.lock.json");
  let lockfile = switch (Shared.Lockfile.lockfile_of_yojson(json)) {
  | Error(a) => failwith("Bad lockfile")
  | Ok(a) => a
  };
  Shared.Files.removeDeep(basedir /+ "node_modules");
  Fetch.fetch(basedir, lockfile);
};

Shared.Wget.init();
switch (Sys.argv) {
  | [|_, "solve", basedir|] => solve(basedir)
  | [|_, "fetch", basedir|] => fetch(basedir)
  | [|_, basedir|] => {
    solve(basedir);
    fetch(basedir);
  }
  | _ => print_endline("Usage: esyi basedir")
};
Shared.Wget.cleanup();
