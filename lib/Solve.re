
type config = [
  | `OpamFile(OpamParserTypes.opamfile)
  | `PackageJson(Yojson.Basic.json)
];

type cache = {
  npmPackages: Hashtbl.t(string, Yojson.Basic.json),
  opamPackages: Hashtbl.t(string, OpamParserTypes.opamfile),
  buildDeps: Hashtbl.t((string, string), (list(Lockfile.solvedDep), list((string, string)))),
};

let addToUniverse = (universe, dep) => {
  ()
};

let makeRequest = (deps, universe) => {
  {
    ...Cudf.default_request,
    install: [("*root*", Some((`Eq, 1)))]
  }
};

let solveDeps = (deps) => {
  let universe = Cudf.empty_universe();
  let preamble = Cudf.default_preamble;
  List.iter(addToUniverse(universe), deps);
  let request = makeRequest(deps, universe);
  switch (Mccs.resolve_cudf(~verbose=true, ~timeout=5., "-notuptodate", (preamble, universe, request))) {
  | None => ()
  | Some(solution) => ()
  };
  /* List.iter(
    (dep) => switch dep {
    | `Opam(op) =>
    | `Npm(np) =>
    },
    deps
  ) */
  []
};

let solve = (config) => {
  let cache = {npmPackages: Hashtbl.create(100), opamPackages: Hashtbl.create(100), buildDeps: Hashtbl.create(20)};
  let (deps, devDeps) = switch config {
  | `OpamFile(file) => OpamFile.process(file)
  | `PackageJson(json) => PackageJson.process(json)
  };

  let lockfile = {
    ...Lockfile.empty,
    specifiedDeps: deps,
    solvedDeps: solveDeps(deps)
  };
};
