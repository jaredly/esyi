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
    Types.esyOpamOverrides: homeDir /+ ".esyi/esy-opam-override",
    opamRepository: homeDir /+ ".esyi/opam-repository"
  }, `PackageJson(json));
  let json = Lockfile.lockfile_to_yojson(lockfile);
  let chan = open_out(basedir /+ "esyi.lock.json");
  Yojson.Safe.pretty_to_channel(chan, json);
  close_out(chan)
};

let fetch = (basedir) => {
  let homeDir = homeDir();
  let json = Yojson.Safe.from_file(basedir /+ "esyi.lock.json");
  let lockfile = switch (Lockfile.lockfile_of_yojson(json)) {
  | Error(a) => failwith("Bad lockfile")
  | Ok(a) => a
  };
  Files.removeDeep(basedir /+ "node_modules");
  Fetch.fetch({
    Types.esyOpamOverrides: homeDir /+ ".esyi/esy-opam-override",
    opamRepository: homeDir /+ ".esyi/opam-repository"
  }, basedir, lockfile);
};
