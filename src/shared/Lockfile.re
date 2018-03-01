
/**
 * Once I've solved all the other things, figure out what build deps I have, and try to cull them down
 * to deduplicate things that fit within the same semver range.
 * Then get them, and resolve deps as though they were top-level, but *sharing the same build_modules cache*.
 * This way build_modules live in a single place.
 *
 *
 * build_modules/ <-- applies to whole tree!
 *    some-tool.1.1.0/
 *      src/
 *      esy_modules/
 *    other-tool.3.4.0/
 * esy_modules/
 *    something
 *      src/
 *    otherdep
 *      src/
 *    third
 *      src/
 * dev_modules/
 *    something
 *      src/
 *    otherdep
 *      src/
 *
 *
 * // for ditry checking
 * requestedDeps: {[key: string]: string},
 * requestedBuildDeps: {[key: string]: string},
 *
 * solvedDeps: {
 *   "name": {
 *     version: "concrete-version",
 *     location: "/path"
 *     source: "url"
 *     hash: "somehash"
 *     solvedBuildDeps: {
 *       "name": "concrete-version"
 *     }
 *   }
 * }
 * solvedBuildDeps: {
 *  "name": "concrete-version"
 * }
 * allBuildDeps: {
 *  "name": {
 *    "concrete-version": {
 *      solvedDeps: {
 *      }
 *      solvedBuildDeps: {
 *        "name": "concrete-version"
 *      }
 *    }
 *  }
 * }
 *
 */

[@deriving yojson]
type realVersion = [
  | `Github(string, string, option(string))
  | `Npm(Types.npmConcrete)
  | `Opam(Types.opamConcrete)
  | `Git(string)
];

[@deriving yojson]
type solvedDep = {
  name: string,
  version: realVersion,
  source: Types.Source.t,
  opamFile: option(string),
  unpackedLocation: string,
  buildDeps: list((string, realVersion)),
  requestedDeps: list(Types.dep),
  requestedBuildDeps: list(Types.dep)
}

/* [@deriving yojson]
and buildDep = {
  bname: string,
  version: realVersion,
  solvedDeps: list(solvedDep),
  buildDeps: list((string, realVersion))
} */

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


let empty = {
  requestedDeps: [],
  /* specifiedDevDeps: [], */
  requestedBuildDeps: [],

  solvedDeps: [],
  solvedBuildDeps: [],
  /* solvedDevDeps: [], */

  allBuildDeps: [],
};