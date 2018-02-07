
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
        ((name, json)) => (NpmVersion.parseConcrete(name), json),
        items
      )
    }
    | _ => failwith("Invalid versions field for registry response to " ++ name)
    }
  }
  | _ => failwith("Invalid registry response for " ++ name)
  }
};

let getFromOpamRegistry = (config, fullName) => {
  let name = OpamFile.withoutScope(fullName);
  let (/+) = Filename.concat;
  let base = config.Types.opamRepository /+ "packages" /+ name;
  switch (Files.readDirectory(base)) {
  | exception _ => failwith("Opam package not in registry: " ++ name)
  | entries => {
    List.map(
      entry => {
        let semver = switch (String.split_on_char('.', entry)) {
        | [] | [_] => OpamVersion.Alpha("", None)
        | [_name, ...items] => {
          OpamVersion.parseConcrete(String.concat(".", items))
        }
        };
        (semver,
        (
          base /+ entry /+ "opam",
          base /+ entry /+ "url",
          name,
          semver
        )
        )
      },
      entries
    )
  }
  }
};
