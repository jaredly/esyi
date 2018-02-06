
switch (Sys.argv) {
  | [|_, "solve", basedir|] => Lib.Main.solve(basedir)
  | [|_, "fetch", basedir|] => Lib.Main.fetch(basedir)
  | [|_, basedir|] => {
    Lib.Main.solve(basedir);
    Lib.Main.fetch(basedir);
  }
  | _ => print_endline("Usage: esyi basedir")
}
