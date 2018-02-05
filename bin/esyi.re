
switch (Sys.argv) {
  | [|_, "solve", basedir|] => Lib.solve(basedir)
  | [|_, "fetch", basedir|] => Lib.fetch(basedir)
  | [|_, basedir|] => {
    Lib.solve(basedir);
    Lib.fetch(basedir);
  }
  | _ => print_endline("Usage: esyi basedir")
}
