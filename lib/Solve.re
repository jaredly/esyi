
type config = [
  | `OpamFile(OpamParserTypes.opamfile)
  | `PackageJson(Yojson.Basic.json)
];

type cache = {
  npmPackages: Hashtbl.t(string, Yojson.Basic.json),
  opamPackages: Hashtbl.t(string, OpamParserTypes.opamfile)
};

let solveDeps = (deps, cache) => {
  let universe = Cudf.empty_universe();
  /* List.iter(
    (dep) => switch dep {
    | `Opam(op) =>
    | `Npm(np) =>
    },
    deps
  ) */
};

let solve = (config) => {
  let cache = {npmPackages: Hashtbl.create(100), opamPackages: Hashtbl.create(100)};
  let (deps, devDeps) = switch config {
  | `OpamFile(file) => OpamFile.process(file)
  | `PackageJson(json) => PackageJson.process(json)
  };

  let _ = solveDeps(deps, cache);
  let lockfile = {
    Lockfile.specifiedDeps: [],
    /* deps, */
    specifiedDevDeps: [],
    /* devDeps, */
    solvedDeps: [],
    /* solveDeps(deps, cache), */
    solvedDevDeps: []
    /* solveDeps(devDeps, cache) */
  };
};
