
[@deriving yojson]
type realVersion = [
  | `Github(string, string, option(string))
  | `Npm(Types.npmConcrete)
  | `Opam(Types.opamConcrete)
  | `Git(string)
  | `File(string)
];

let viewRealVersion: realVersion => string = v => switch v {
| `Github(user, repo, ref) => "github-" ++ user ++ "__" ++ repo ++ (switch ref { | Some(x) => "__" ++ x | None => ""})
| `Git(s) => "git-" ++ s
| `Npm(t) => "npm-" ++ Types.viewNpmConcrete(t)
| `Opam(t) => "opam-" ++ Types.viewOpamConcrete(t)
| `File(s) => "local-file"
};

let plainVersionNumber = v => switch v {
| `Github(user, repo, ref) => user ++ "__" ++ repo ++ (switch ref { | Some(x) => "__" ++ x | None => ""})
| `Git(s) => s
| `Npm(t) => Types.viewNpmConcrete(t)
| `Opam(t) => Types.viewOpamConcrete(t)
/* TODO hash the file path or something */
| `File(s) => "local-file-0000"
};

type json = Yojson.Safe.json;
let json_to_yojson = x => x;
let json_of_yojson = x => Result.Ok(x);

let module SolvedDep = {
  [@deriving yojson]
  type t = {
    name: string,
    version: realVersion,
    source: Types.Source.t,
    /* TODO fold this into Source */
    opamFile: option((json, list((string, string)), list(string))),
    buildDeps: list((string, realVersion)),
    requestedDeps: Types.depsByKind
  };
};

[@deriving yojson]
type lockfile = {
  requestedDeps: Types.depsByKind,
  /* TODO dev deps, they need to be split into devBuildDeps probably */
  /* solvedDevDeps: list(SolvedDep.t), */

  solvedDeps: list(SolvedDep.t),
  solvedBuildDeps: list((string, realVersion)),
  /* A mapping of name:version to the solved dependencies, and the solved build deps */
  allBuildDeps: list((string, list((SolvedDep.t, list(SolvedDep.t))))),
};

let empty = {
  requestedDeps: {
    runtime: [],
    build: [],
    npm: [],
    dev: [],
  },

  solvedDeps: [],
  solvedBuildDeps: [],
  /* solvedDevDeps: [], */

  allBuildDeps: [],
};