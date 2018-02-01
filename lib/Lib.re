


let hello = () => {
  let json = Yojson.Basic.from_file("./package.json");
  let lockfile = Solve.solve(`PackageJson(json));
  let json = Lockfile.lockfile_to_yojson(lockfile);
  let chan = open_out("./esyi.lock.json");
  Yojson.Safe.pretty_to_channel(chan, json);
  close_out(chan)
};



