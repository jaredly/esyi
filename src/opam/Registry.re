
open Shared;

let filterNils = items => items |> List.filter(x => x != None) |> List.map((Some(x)) => x);

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
        | [] | [_] => Types.Alpha("", None)
        | [_name, ...items] => {
          OpamVersion.parseConcrete(String.concat(".", items))
        }
        };
        let manifest = OpamFile.parseManifest((name, semver), OpamParser.file(base /+ entry /+ "opam"));
        if (!manifest.OpamFile.available) {
          None
        } else {
          Some(
            (semver,
            (
              base /+ entry /+ "opam",
              base /+ entry /+ "url",
              name,
              semver
            ))
          )
        }
      },
      entries
    ) |>  filterNils
  }
  }
};