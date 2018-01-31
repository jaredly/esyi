
type triple = (int, int, int, option(string));

type semver =
  | Any
  | Exactly(triple)
  | UpToMinor(triple)
  | UpToMajor(triple);

type dep =
  | Npm(string, semver)
  | Github(string) /* maybe cover auth here, maybe subdir support */
  | Opam(string, semver) /* opam allows a bunch of weird stuff. for now I'm just doing semver */
  | Git(string)
  ;

