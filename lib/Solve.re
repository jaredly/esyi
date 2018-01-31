
type config = [
  | `OpamFile(OpamParserTypes.opamfile)
  | `PackageJson(Yojson.Basic.json)
];

type cache = {
  npmPackages: Hashtbl.t(string, Yojson.Basic.json),
  opamPackages: Hashtbl.t(string, OpamParserTypes.opamfile),
  buildDeps: Hashtbl.t((string, string), (list(Lockfile.solvedDep), list((string, string)))),
};

let addToUniverse = (universe, versionCache, dep) => {
  ()
};

let versionTicker = ref(0);

let nextVersion = () => {
  incr(versionTicker);
  versionTicker^
};

let matchesSource = (source, versionCache, package) => {
  let version = switch (Hashtbl.find(versionCache, (package.Cudf.package, package.Cudf.version))) {
  | exception Not_found => failwith("Tried to find a package that wasn't listed in the versioncache " ++ package.Cudf.package)
  | version => version
  };
  switch (source, version) {
  | (Types.Github(source), `Github(source_)) when source == source_ => true
  | (Npm(semver), `Version(s)) when NpmSemver.matches(s, semver) => true
  | _ => false
  }
};

let cudfDep = (universe, versionCache, (name, source)) => {
  let available = Cudf.lookup_packages(universe, name)
  |> List.filter(matchesSource(source, versionCache))
  |> List.map(package => (package.Cudf.package, Some((`Eq, package.Cudf.version))));
  if (available == []) {
    failwith("No package found for " ++ name)
  } else {
    available
  }
};

let rootPackage = (deps, universe, versionCache) => {
  {
    ...Cudf.default_package,
    package: "root",
    version: nextVersion(),
    depends: List.map(cudfDep(universe, versionCache), deps)
  }
};

let makeRequest = (deps, universe, versionCache) => {
  let root = rootPackage(deps, universe, versionCache);
  Cudf.add_package(universe, root);
  {
    ...Cudf.default_request,
    install: [(root.Cudf.package, Some((`Eq, root.Cudf.version)))]
  }
};

let solveDeps = (deps) => {
  let versionCache = Hashtbl.create(100);
  let universe = Cudf.empty_universe();
  let preamble = Cudf.default_preamble;
  List.iter(addToUniverse(universe, versionCache), deps);
  let request = makeRequest(deps, universe, versionCache);
  switch (Mccs.resolve_cudf(~verbose=true, ~timeout=5., "-notuptodate", (preamble, universe, request))) {
  | None => ()
  | Some((a, universe)) => {
    let packages = Cudf.get_packages(~filter=(p => p.Cudf.installed), universe);
    print_endline("Installed packages:");
    List.iter(p => print_endline(p.Cudf.package), packages)
  }
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
  print_endline("Dones")
};
