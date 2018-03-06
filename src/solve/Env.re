
module Npm = {
  type t = {
    source: Shared.Types.PendingSource.t,
    resolved: Shared.Types.npmConcrete,
    requested: Shared.Types.npmRange,
    dependencies: list((string, option(t)))
  };
};

type resolved = (string, Shared.Types.requestedDep, Shared.Lockfile.realVersion);

type fullPackage = {
  name: string,
  version: Shared.Lockfile.realVersion,
  source: Shared.Types.PendingSource.t, /* will lock down before committing to lockfile */
  runtime: list(resolved),
  build: list(resolved),
  npm: list((string, Npm.t)),
};

type rootPackage = {
  package: fullPackage,
  runtimeBag: list(fullPackage)
};

type target = Default | Arch(string) | ArchSubArch(string, string);

type t = {
  targets: list((target, rootPackage)),
  buildDependencies: list(rootPackage)
};