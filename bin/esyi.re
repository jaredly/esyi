
switch (Sys.argv) {
  | [|_, basedir|] => {
    Lib.solve(basedir);
    Lib.fetch(basedir);
  }
  | _ => print_endline("Usage: esyi basedir")
}
