open Opam;
open Npm;

let getDeps = manifest => {
  let (deps, buildDeps, _) = switch manifest {
  | `OpamFile(opam) => OpamFile.process(opam)
  | `PackageJson(json) => PackageJson.process(json)
  };
  (deps, buildDeps)
};

let getArchive = manifest => switch manifest {
| `OpamFile(opam) => OpamFile.getArchive(opam)
| `PackageJson(json) => PackageJson.getArchive(json)
};