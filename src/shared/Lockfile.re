
[@deriving yojson]
type realVersion = [
  | `Github(string, string, option(string))
  | `Npm(Types.npmConcrete)
  | `Opam(Types.opamConcrete)
  | `Git(string)
];

let viewRealVersion: realVersion => string = v => switch v {
| `Github(user, repo, ref) => "github-" ++ user ++ "__" ++ repo ++ (switch ref { | Some(x) => "__" ++ x | None => ""})
| `Git(s) => "git-" ++ s
| `Npm(t) => "npm-" ++ Types.viewNpmConcrete(t)
| `Opam(t) => "opam-" ++ Types.viewOpamConcrete(t)
};

let plainVersionNumber = v => switch v {
| `Github(user, repo, ref) => user ++ "__" ++ repo ++ (switch ref { | Some(x) => "__" ++ x | None => ""})
| `Git(s) => s
| `Npm(t) => Types.viewNpmConcrete(t)
| `Opam(t) => Types.viewOpamConcrete(t)
};

type json = Yojson.Safe.json;
let json_to_yojson = x => x;
let json_of_yojson = x => Result.Ok(x);

[@deriving yojson]
type solvedDep = {
  name: string,
  version: realVersion,
  source: Types.Source.t,
  opamFile: option((json, list((string, string)), list(string))),
  unpackedLocation: string,
  buildDeps: list((string, realVersion)),
  requestedDeps: list(Types.dep),
  requestedBuildDeps: list(Types.dep)
}

[@deriving yojson]
and lockfile = {
  requestedDeps: list(Types.dep),
  requestedBuildDeps: list(Types.dep),
  /* TODO dev deps, they need to be split into devBuildDeps probably */
  /* specifiedDevDeps: list(Types.dep), */
  /* solvedDevDeps: list(solvedDep), */

  solvedDeps: list(solvedDep),
  solvedBuildDeps: list((string, realVersion)),
  /* A mapping of name:version to the solved dependencies, and the solved build deps */
  allBuildDeps: list((string, list((solvedDep, list(solvedDep))))),
};

let empty = {
  requestedDeps: [],
  /* specifiedDevDeps: [], */
  requestedBuildDeps: [],

  solvedDeps: [],
  solvedBuildDeps: [],
  /* solvedDevDeps: [], */

  allBuildDeps: [],
};