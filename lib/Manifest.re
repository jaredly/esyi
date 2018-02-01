
let getDeps = config => {
  let (deps, buildDeps, _) = switch config {
  | `OpamFile(opam) => OpamFile.process(opam)
  | `PackageJson(json) => PackageJson.process(json)
  };
  (deps, buildDeps)
};

let getArchive = config => switch config {
| `OpamFile(opam) => OpamFile.getArchive(opam)
| `PackageJson(json) => PackageJson.getArchive(json)
};