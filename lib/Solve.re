
type config = [
  | `OpamFile(OpamParserTypes.opamfile)
  | `PackageJson(Yojson.Basic.json)
];


let solve = (config) => {

};
