
open OpamParserTypes;

type manifest = {
  fileName: string,
  build: list(list(string)),
  install: list(list(string)),
  patches: list(string), /* these should be absolute */
  files: list((string, string)), /* absname, relname */
  deps: list((string, Semver.semver)),
  buildDeps: list((string, Semver.semver)),
  devDeps: list((string, Semver.semver)),
  source: option((string, option(string))),
};
/* TODO parse an opam file into this manifest format */
/* Then parse our fancy override json or yaml thing... I think? */

type thinManifest = (string, string);

let rec findVariable = (name, items) => switch items {
| [] => None
| [Variable(_, n, v), ..._] when n == name => Some(v)
| [_, ...rest] => findVariable(name, rest)
};

let (|?) = (a, b) => switch a { | None => b | Some(a) => a };

let opName = op => switch op {
  | `Leq => "<="
  | `Lt => "<"
  | `Neq => "!="
  | `Eq => "="
  | `Geq => ">="
  | `Gt => ">"
};

let fromPrefix = (op, version) => switch op {
  | `Eq => Semver.Exactly(VersionNumber.versionNumberNumber(version))
  | `Geq => AtLeast(VersionNumber.versionNumberNumber(version))
  | _ => {
    failwith("Unexpected prefix op for version " ++ opName(op) ++ " " ++ version)
  }
};

let withScope = name => "@opam/" ++ name;

let withoutScope = fullName => {
  let ln = 6;
  if (String.sub(fullName, 0, ln) != "@opam/") {
    failwith("Opam name not prefixed: " ++ fullName)
  };
  String.sub(fullName, ln, String.length(fullName) - ln);
};

let toDep = opamvalue => {
  let (name, s) = switch opamvalue {
  | String(_, name) => (name, Semver.Any)
  | Option(_, String(_, name), [Prefix_relop(_, op, String(_, version))]) => (name, fromPrefix(op, version))
  | Option(_, String(_, name), [y]) => {
    print_endline("Unexpected option " ++ name ++ " -- pretending its any " ++
    OpamPrinter.value(opamvalue));
    (name, Any)
  }
  | _ => {
    failwith("Can't parse this opam dep " ++ OpamPrinter.value(opamvalue))
  }
  };
  (withScope(name), s)
};

let processDeps = deps => {
  let deps = switch (deps) {
  | None => []
  | Some(List(_, items)) => items
  | Some(Group(_, items)) => items
  | _ => failwith("Can't handle the dependencies")
  };

  List.fold_left(
    ((deps, buildDeps, devDeps), dep) => {
      try (switch dep {
      /* This doesn't cover the case where there's an OR that has "test" on each side */
      | Option(_, value, [Ident(_, "build")]) => (deps, [toDep(value), ...buildDeps], devDeps)
      | Option(_, value, [Ident(_, "test")]) => (deps, buildDeps, [toDep(value), ...devDeps])
      | Option(_, String(_, name), [
        Logop(_, `And, Ident(_, "build"), Prefix_relop(_, op, String(_, version)))
      ]) => (deps, [(withScope(name), fromPrefix(op, version)), ...buildDeps], devDeps)
      | Option(_, String(_, name), [
        Logop(_, `And, Ident(_, "test"), Prefix_relop(_, op, String(_, version)))
      ]) => (deps, buildDeps, [(withScope(name), fromPrefix(op, version)), ...devDeps])
      | _ => ([toDep(dep), ...deps], buildDeps, devDeps);
      }) {
        | Failure(message) => {
          print_endline("Bailing on a dep " ++ message);
          (deps, buildDeps, devDeps)
        }
      }
    },
    ([], [], []),
    deps
  );
};

let filterMap = (fn, items) => {
  List.map(fn, items) |> List.filter(x => x != None) |> List.map(x => switch (x) { | Some(x) => x | None => assert(false)})
};

let variables = [
  ("jobs", "4"),
  ("make", "make"),
  ("bin", "$cur__install/bin"),
  ("lib", "$cur__install/lib"),
  ("man", "$cur__install/man"),
];

let replaceVariables = string => {
  List.fold_left(
    (string, (name, res)) => {
      Str.global_replace(
        Str.regexp_string("%{" ++ name ++ "}%"),
        res,
        string
      )
    },
    string,
    variables
  )
};

let processCommandList = item => {
  switch(item) {
  | None => []
  | Some(List(_, items))
  | Some(Group(_, items)) => {

    items |> filterMap(item => {
      switch item {
      | List(_, items) => {
        let strings = items |> filterMap(item => {
          switch item {
          | String(_, name) => Some(replaceVariables(name))
          | Ident(_, ident) => {
            switch (List.assoc_opt(ident, variables)) {
            | Some(string) => Some(string)
            | None => {
              print_endline("Missing vbl" ++ ident);
              None
            }
            }
          };
          | _ => {
            print_endline("Bad build arg " ++ OpamPrinter.value(item));
            None
          }
          };
        });
        Some(strings)
      }
      | _ => {
        print_endline("Skipping a non-list build thing " ++ OpamPrinter.value(item));
        None
      }
      }
    });
  }

  | Some(Ident(_, ident)) => {
    switch (List.assoc_opt(ident, variables)) {
    | Some(string) => [[string]]
    | None => {
      print_endline("Missing vbl" ++ ident);
      []
    }
    }

  }
  | Some(item) => failwith("Unexpected type for a command list: " ++ OpamPrinter.value(item))
  };
};

let processStringList = item => {
  let items = switch(item) {
  | None => []
  | Some(List(_, items))
  | Some(Group(_, items)) => items
  | Some(item) => failwith("Unexpected type for a string list: " ++ OpamPrinter.value(item))
  };
  items |> filterMap(item => {
    switch item {
      | String(_, name) => Some(name)
      | _ => {
        print_endline("Bad string list item arg " ++ OpamPrinter.value(item));
        None
      }
    }
  });
};

let findArchive = contents => {
  switch (findVariable("archive", contents)) {
  | Some(String(_, archive)) => archive
  | _ => {
    switch (findVariable("http", contents)) {
    | Some(String(_, archive)) => archive
    | _ =>
    switch (findVariable("src", contents)) {
    | Some(String(_, archive)) => archive
    | _ => failwith("Invalid url file - no archive")
    }
  }
  }
  }
};

let parseUrlFile = ({file_contents}) => {
  let archive = findArchive(file_contents);
  switch (findVariable("checksum", file_contents)) {
  | Some(String(_, checksum)) => Some((archive, Some(checksum)))
  | _ => Some((archive, None))
  }
};

let parseManifest = ({file_contents, file_name}) => {
  let baseDir = Filename.dirname(file_name);
  let (deps, buildDeps, devDeps) = processDeps(findVariable("depends", file_contents));
  {
    fileName: file_name,
    build: processCommandList(findVariable("build", file_contents)),
    install: processCommandList(findVariable("install", file_contents)),
    patches: processStringList(findVariable("patches", file_contents)) |> List.map(Filename.concat(baseDir)),
    files: processStringList(findVariable("files", file_contents)) |> List.map(m => (Filename.concat(baseDir, m), m)),
    deps,
    buildDeps,
    devDeps,
    source: None,
  };
};

let getManifest = ((opam, url)) => {
  {
    ...parseManifest(OpamParser.file(opam)),
    source: Files.exists(url) ? parseUrlFile(OpamParser.file(url)) : None
  }
};

let getArchive = ({source}) => source;

let toDepSource = ((name, semver)) => (name, Types.Opam(semver));

let process = ({deps, buildDeps, devDeps}) => {
  (deps |> List.map(toDepSource), buildDeps |> List.map(toDepSource), devDeps |> List.map(toDepSource))
};

let commandListToJson = e => e |> List.map(items => `List(List.map(item => `String(item), items)));

let toPackageJson = (filename, name, version) => {
  let file = OpamParser.file(filename);
  print_endline("opam file " ++ filename);
  let manifest = parseManifest(file);

  `Assoc([
    ("name", `String(name)),
    ("version", `String(Lockfile.plainVersionNumber(version))),
    ("esy", `Assoc([
      ("build", `List(commandListToJson(manifest.build))),
      ("install", `List(commandListToJson(manifest.install))),
      /* ("buildsInSource", "_build") */
    ])),
    ("dependencies", `Assoc(
      (manifest.deps |> List.map(((name, _)) => (name, `String("*"))))
      @
      (manifest.buildDeps |> List.map(((name, _)) => (name, `String("*"))))
    ))
  ])
};

/* let process = (parsed: OpamParserTypes.opamfile) => switch parsed {
  | { file_contents, file_name } => switch file_contents {
  | [] => failwith((""))
  | [item, ..._] => switch item {
  | OpamParserTypes.Section(_, _) => failwith((""))
  | OpamParserTypes.Variable(a, b, c) => switch c {
  | OpamParserTypes.Bool(_, _) => failwith ("")
  | OpamParserTypes.Int(_, _) => failwith ("")
  | OpamParserTypes.String(_, _) => failwith ("")
  | OpamParserTypes.Relop(_, _, _, _) => failwith ("")
  | OpamParserTypes.Prefix_relop(_, r, _) => switch r {
  | `Leq => failwith ("")
  | `Lt => failwith ("")
  | `Neq => failwith ("")
  | `Eq => failwith ("")
  | `Geq => failwith ("")
  | `Gt => failwith ("")
  }
  | OpamParserTypes.Logop(_, l, _, _) => failwith("")
  | OpamParserTypes.Pfxop(_, p, _) => failwith ("")
  | OpamParserTypes.Ident(_, _) => failwith ("")
  | OpamParserTypes.List(_, _) => failwith ("")
  | OpamParserTypes.Group(_, _) => failwith ("")
  | OpamParserTypes.Option(_, _, _) => failwith ("")
  | OpamParserTypes.Env_binding(_, _, _, _) => failwith ("")
  }
  }
  }
  }; */
