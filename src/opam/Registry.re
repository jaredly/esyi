
open Shared;

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