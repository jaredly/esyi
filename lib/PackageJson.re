open Cudf;
open Types;

let getOpam = name => {
  let ln = 6;
  if (String.length(name) > ln && String.sub(name, 0, ln) == "@opam/") {
    Some(name)
    /* Some(String.sub(name, ln, String.length(name) - ln)) */
  } else {
    None
  }
};

let isGithub = value => {
  Str.string_match(Str.regexp("[a-zA-Z0-9-]+/[a-zA-Z0-9_-]+(#.+)?"), value, 0)
};

let parseNpmSource = ((name, value)) => {
  switch (getOpam(name)) {
  | Some(name) => (name, Opam(Semver.parseSemver(value)))
  | None => {
    (name, switch (Semver.parseSemver(value)) {
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

let toDep = ((name, value)) => {
  let value = switch value {
  | `String(value) => value
  | _ => failwith("Unexpected dep value: " ++ Yojson.Basic.to_string(value))
  };

  parseNpmSource((name, value))
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
  | `Assoc(items) => {
    let dependencies = switch (List.assoc("dependencies", items)) {
    | exception Not_found => []
    | `Assoc(items) => items
    | _ => failwith("Unexpected value for dependencies")
    };
    let buildDependencies = switch (List.assoc("buildDependencies", items)) {
    | exception Not_found => []
    | `Assoc(items) => items
    | _ => failwith("Unexpected value for build deps")
    };
    let devDependencies = switch (List.assoc("devDependencies", items)) {
    | exception Not_found => []
    | `Assoc(items) => items
    | _ => failwith("Unexpected value for dev deps")
    };
    (dependencies |> List.map(toDep), buildDependencies |> List.map(toDep), devDependencies |> List.map(toDep))
  }
  | _ => failwith("Invalid package.json")
  };
};

let getArchive = (json) => {
  switch json {
  | `Assoc(items) => {
    switch (List.assoc("dist", items)) {
    | `Assoc(items) => {
      let archive = switch(List.assoc("tarball", items)) {
      | `String(archive) => archive
      | _ => failwith("Bad tarball")
      };
      let checksum = switch(List.assoc("shasum", items)) {
      | `String(checksum) => checksum
      | _ => failwith("Bad checksum")
      };
      Some((archive, Some(checksum)))
    }
    | _ => failwith("bad dist")
    }
  }
  | _ => failwith("bad json manifest")
  }
};
