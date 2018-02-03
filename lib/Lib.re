
let (/+) = Filename.concat;

let solve = (basedir) => {
  let json = Yojson.Basic.from_file(basedir /+ "package.json");
  let lockfile = Solve.solve({
    Types.esyOpamOverrides: "/Users/jared/.esy/esy-opam-override"
  }, `PackageJson(json));
  let json = Lockfile.lockfile_to_yojson(lockfile);
  let chan = open_out(basedir /+ "esyi.lock.json");
  Yojson.Safe.pretty_to_channel(chan, json);
  close_out(chan)
};

let fetch = (basedir) => {
  let json = Yojson.Safe.from_file(basedir /+ "esyi.lock.json");
  let lockfile = switch (Lockfile.lockfile_of_yojson(json)) {
  | Error(a) => failwith("Bad lockfile")
  | Ok(a) => a
  };
  Fetch.fetch({
    Types.esyOpamOverrides: "/Users/jared/.esy/esy-opam-override"
  }, basedir, lockfile);
};