open Opam;
open Npm;

let getDeps = manifest => {
  let depsByKind = switch manifest {
  | `OpamFile(opam) => OpamFile.process(opam)
  | `PackageJson(json) => PackageJson.process(json)
  };
  depsByKind
};

let getArchive = manifest => switch manifest {
| `OpamFile(opam) => OpamFile.getArchive(opam)
| `PackageJson(json) => PackageJson.getArchive(json)
};