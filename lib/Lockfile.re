
type solvedDep = {
  name: string,
  version: string,
  archive: string,
  checksum: string,
};

type lockfile = {
  specifiedDeps: list(Types.dep),
  specifiedDevDeps: list(Types.dep),
  solvedDeps: list(solvedDep),
  solvedDevDeps: list(solvedDep),
};
