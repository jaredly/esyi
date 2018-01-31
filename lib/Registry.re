
let getGithubManifest = url => {
  failwith("not impl get github")
};

let getFromNpmRegistry = name => {
  let name = Str.global_replace(Str.regexp("/"), "%2f", name);
  let json = Wget.get("http://registry.npmjs.org/" ++ name) |> Yojson.Basic.from_string;
  switch json {
  | `Assoc(items) => {
    switch (List.assoc("versions", items)) {
    | exception Not_found => {
      print_endline(Yojson.Basic.to_string(json));
      failwith("No versions field in the registry result for " ++ name)
    }
    | `Assoc(items) => {
      List.map(
        ((name, json)) => (NpmSemver.tripleNumber(name), json),
        items
      )
    }
    | _ => failwith("Invalid versions field for registry response to " ++ name)
    }
  }
  | _ => failwith("Invalid registry response for " ++ name)
  }
};

let getFromOpamRegistry = fullName => {
  let ln = 6;
  if (String.sub(fullName, 0, ln) != "@opam/") {
    failwith("Opam name not prefixed: " ++ fullName)
  };
  let name = String.sub(fullName, ln, String.length(fullName) - ln);
  let base = "/Users/jared/.esy/opam-repository/packages/" ++ name;
  let (/+) = Filename.concat;
  switch (Files.readDirectory(base)) {
  | exception _ => failwith("Opam package not in registry: " ++ name)
  | entries => {
    List.map(
      entry => {
        let semver = switch (String.split_on_char('.', entry)) {
        | [] | [_] => (0, 0, 0, None)
        | [_name, ...items] => {
          try (NpmSemver.handleTripleParts(items)) {
          | _ => {
            print_endline("Can't handle the version for " ++ name ++ ": " ++ entry);
            (0, 0, 0, Some(String.concat(".", items)))
          }
          }
        }
        };
        (semver, base /+ entry /+ "opam")
      },
      entries
    )
  }
  }
};