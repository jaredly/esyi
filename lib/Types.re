
type triple = (int, int, int, option(string));

type semver =
  | Any
  | Exactly(triple)
  | UpToMinor(triple)
  | UpToMajor(triple);

type depSource =
  | Npm(semver)
  | Github(string) /* maybe cover auth here, maybe subdir support */
  | Opam(semver) /* opam allows a bunch of weird stuff. for now I'm just doing semver */
  | Git(string)
  ;

type dep = (string, depSource);
