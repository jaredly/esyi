


let hello = () => print_endline("HI");


type config = [
  | `OpamFile(OpamParserTypes.opamfile)
  | `PackageJson(Yojson.Basic.json)
];
