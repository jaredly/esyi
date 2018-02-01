
open OpamParserTypes;

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
  | `Eq => Types.Opam(Exactly(VersionNumber.versionNumberNumber(version)))
  | `Geq => Types.Opam(AtLeast(VersionNumber.versionNumberNumber(version)))
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
  | String(_, name) => (name, Types.Opam(Semver.Any))
  | Option(_, String(_, name), [Prefix_relop(_, op, String(_, version))]) => (name, fromPrefix(op, version))
  | Option(_, String(_, name), [y]) => {
    print_endline("Unexpected option " ++ name ++ " -- pretending its any " ++
    OpamPrinter.value(opamvalue));
    (name, Types.Opam(Any))
  }
  | _ => {
    failwith("Can't parse this opam dep " ++ OpamPrinter.value(opamvalue))
  }
  };
  (withScope(name), s)
};

type thinManifest = (string, string);
type manifest = (
  OpamParserTypes.opamfile
  ,
  option(OpamParserTypes.opamfile)
);

let getManifest = ((opam, url)) => {
  (
    OpamParser.file(opam),
    Files.exists(url) ? Some(OpamParser.file(url)) : None
  )
};

let process = (({file_contents, file_name}, _)) => {
  /* print_endline("processing" ++ file_name); */
  let deps = switch (findVariable("depends", file_contents)) {
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

let toPackageJson = (filename, name, version) => {
  let file = OpamParser.file(filename);
  print_endline("opam file " ++ filename);
  let (deps, buildDeps, devDeps) = process((file, ()));
  let build = switch(findVariable("build", file.file_contents)) {
  | None => []
  | Some(List(_, items))
  | Some(Group(_, items)) => items
  | _ => failwith("Bad opam build " ++ filename)
  };
  let build = build |> filterMap(item => {
    switch item {
    | List(_, items) => {
      let strings = items |> filterMap(item => {
        switch item {
        | String(_, name) => Some(`String(replaceVariables(name)))
        | Ident(_, ident) => {
          switch (List.assoc_opt(ident, variables)) {
          | Some(string) => Some(`String(string))
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
        /* | Ident(_, "make") => Some(`String("make"))
        | Ident(_, ("bin" | "lib" | "man") as v) => `String("$cur__install/" ++ v)
        } */
      });
      Some(`List(strings))
    }
    | _ => {
      print_endline("Skipping a non-list build thing " ++ OpamPrinter.value(item));
      None
    }
    }
  });

  `Assoc([
    ("name", `String(name)),
    ("version", `String(Lockfile.plainVersionNumber(version))),
    ("esy", `Assoc([
      ("build", `List(build)),
      /* ("buildsInSource", "_build") */
    ])),
    ("dependencies", `Assoc(
      (deps |> List.map(((name, _)) => (name, `String("*"))))
      @
      (buildDeps |> List.map(((name, _)) => (name, `String("*"))))
    ))
  ])
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

let getArchive = ((_, url)) => {
  switch url {
  | None => (None, "no checksum")
  | Some({file_contents, file_name}) => {
    print_endline(file_name);
    let archive = findArchive(file_contents);
    switch (findVariable("checksum", file_contents)) {
    | Some(String(_, checksum)) => (Some(archive), checksum)
    | _ => failwith("Invalid url file - no checksum")
    }
  }
  }
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
