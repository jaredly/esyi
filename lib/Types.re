
[@deriving yojson]
type triple = (int, int, int, option(string));

[@deriving yojson]
type semver =
  | Any
  | Exactly(triple)
  | AtLeast(triple)
  /* | GreaterThan(triple)
  | AtMost(triple)
  | LessThan(triple) */
  | UpToMinor(triple)
  | UpToMajor(triple);

[@deriving yojson]
type depSource =
  | Npm(semver)
  | Github(string) /* maybe cover auth here, maybe subdir support */
  | Opam(semver) /* opam allows a bunch of weird stuff. for now I'm just doing semver */
  | Git(string)
  ;

[@deriving yojson]
type dep = (string, depSource);

let viewTriple = ((m, i, p, r)) => {
  let base = string_of_int(m) ++ "." ++ string_of_int(i) ++ "." ++ string_of_int(p);
  switch r {
  | None => base
  | Some(e) => base ++ "-" ++ e
  }
};

let after = (a, prefix) => {
  let al = String.length(a);
  let pl = String.length(prefix);
  if (al > pl && String.sub(a, 0, pl) == prefix) {
    Some(String.sub(a, pl, al - pl))
  } else {
    None
  }
};

let compareExtra = (a, b) => {
  switch (a, b) {
  | (Some(a), Some(b)) => {
    switch (after(a, "beta"), after(b, "beta")) {
    | (Some(a), Some(b)) => try(int_of_string(a) - int_of_string(b)) { | _ => compare(a, b) }
    | _ => switch (after(a, "alpha"), after(b, "alpha")) {
      | (Some(a), Some(b)) => try(int_of_string(a) - int_of_string(b)) { | _ => compare(a, b) }
      | _ => try(int_of_string(a) - int_of_string(b)) { | _ => compare(a, b) }
      }
    }
  }
  | _ => compare(a, b)
  }
};

let compareTriples = ((ma, ia, pa, ra), (mb, ib, pb, rb)) => {
  ma != mb
  ? (ma - mb)
  : (
    ia != ib
    ? (ia - ib)
    : (
      pa != pb
      ? (pa - pb)
      : compareExtra(ra, rb)
    )
  )
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

let viewReq = req => switch req {
| Github(s) => "github: " ++ s
| Git(s) => "git: " ++ s
| Npm(t) => "npm: " ++ viewSemver(t)
| Opam(t) => "opam: " ++ viewSemver(t)
};