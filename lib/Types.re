
type triple = (int, int, int, option(string));

type semver =
  | Any
  | Exactly(triple)
  | AtLeast(triple)
  /* | GreaterThan(triple)
  | AtMost(triple)
  | LessThan(triple) */
  | UpToMinor(triple)
  | UpToMajor(triple);

type depSource =
  | Npm(semver)
  | Github(string) /* maybe cover auth here, maybe subdir support */
  | Opam(semver) /* opam allows a bunch of weird stuff. for now I'm just doing semver */
  | Git(string)
  ;

type dep = (string, depSource);

let viewTriple = ((m, i, p, r)) => {
  let base = string_of_int(m) ++ "." ++ string_of_int(i) ++ "." ++ string_of_int(p);
  switch r {
  | None => base
  | Some(e) => base ++ "-" ++ e
  }
};

let viewSemver = semver => switch  semver {
  | Any => "any"
  | Exactly(t) => "exactly " ++ viewTriple(t)
  | UpToMajor(t) => "^" ++ viewTriple(t)
  | UpToMinor(t) => "~" ++ viewTriple(t)
  | AtLeast(t) => ">=" ++ viewTriple(t)
  /* | AtMost(t) => "<=" ++ viewTriple(t)
  | GreaterThan(t) => ">" ++ viewTriple(t)
  | LessThan(t) => "<" ++ viewTriple(t) */
};