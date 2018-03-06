
module Npm = {
  type t('sourceType) = {
    source: 'sourceType,
    resolved: Shared.Types.npmConcrete,
    requested: Shared.Types.npmRange,
    dependencies: list((string, option(t('sourceType))))
  };
};

type resolved = (string, Shared.Types.requestedDep, Shared.Lockfile.realVersion);

type fullPackage('sourceType) = {
  name: string,
  version: Shared.Lockfile.realVersion,
  source: 'sourceType, /* pending until I need to lock it down */
  runtime: list(resolved),
  build: list(resolved),
  npm: list((string, Npm.t('sourceType))),
};

type rootPackage('sourceType) = {
  package: fullPackage('sourceType),
  runtimeBag: list(fullPackage('sourceType))
};

type target = Default | Arch(string) | ArchSubArch(string, string);

type t('sourceType) = {
  targets: list((target, rootPackage('sourceType))),
  buildDependencies: list(rootPackage('sourceType))
};

let mapSnd = (mapper, (a, b)) => (a, mapper(b));
let mapOpt = (mapper, a) => switch a { | None => None | Some(x) => Some(mapper(x))};

let rec mapNpm = (mapper, npm) => {
  ...npm,
  Npm.source: mapper(npm.Npm.source),
  dependencies: List.map(mapSnd(mapOpt(mapNpm(mapper))), npm.Npm.dependencies)
};

let mapFull = (mapper, full) => {
  ...full,
  source: mapper(full.source)
};

let mapRoot = (mapper, root) => {
  package: mapFull(mapper, root.package),
  runtimeBag: List.map(mapFull(mapper), root.runtimeBag)
};

let map = (mapper, t) => {
  targets: List.map(mapSnd(mapRoot(mapper)), t.targets),
  buildDependencies: List.map(mapRoot(mapper), t.buildDependencies),
};