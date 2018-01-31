open Cudf;
open Types;

let getOpam = name => {
  if (String.length(name) > 5 && String.sub(name, 0, 5) == "@opam") {
    Some(String.sub(name, 5, String.length(name) - 5))
  } else {
    None
  }
};

let isGithub = value => {
  Str.string_match(Str.regexp("[a-zA-Z0-9-]+/[a-zA-Z0-9_-]+(#.+)?"), value, 0)
};

let toDep = ((name, value)) => {
  let value = switch value {
  | `String(value) => value
  | _ => failwith("Unexpected dep value: " ++ Yojson.Basic.to_string(value))
  };

  switch (getOpam(name)) {
  | Some(name) => (name, Opam(NpmSemver.parseTriple(value)))
  | None => {
    (name, switch (NpmSemver.parseTriple(value)) {
    | exception Failure(message) => {
      if (isGithub(value)) {
        Github(value)
      } else {
        Git(value)
      }
    }
    | x => Npm(x)
    })
  }
  }
};

/**
 * Parse the deps
 *
 * - For each dep
 *   - grab the manifest (todo cache)
 *   - add all the matching packages to the universe
 *   - if a given version hasn't been added, then recursively process it
 * - how do I do this incrementally?
 * - or, how do I do it serially, but in a way that I can easily move to lwt?
 *
 */
let process = (parsed) => {
  /* let parsed = Yojson.Basic.from_string(contents); */
  switch parsed {
  | `Assoc items => {
    let dependencies = switch (List.assoc("dependencies", items)) {
    | exception Not_found => []
    | `Assoc(items) => items
    | _ => failwith("Unexpected value for dependencies")
    };
    let devDependencies = switch (List.assoc("devDependencies", items)) {
    | exception Not_found => []
    | `Assoc(items) => items
    | _ => failwith("Unexpected value for dev deps")
    };
    (dependencies |> List.map(toDep), devDependencies |> List.map(toDep))
  }
  | _ => failwith("Invalid package.json")
  };
};
