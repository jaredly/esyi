
open OpamParserTypes;

let rec findVariable = (name, items) => switch items {
| [] => None
| [Variable(_, n, v), ..._] when n == name => Some(v)
| [_, ...rest] => findVariable(name, rest)
};

let (|?) = (a, b) => switch a { | None => b | Some(a) => a };

let process = ({file_contents, file_name}) => {
  let deps = switch (findVariable("depends", file_contents)) {
  | None => []
  | Some(List(_, items)) => items
  | Some(Group(_, items)) => items
  | _ => failwith("Can't handle the dependencies")
  };

  List.fold_left(
    ((deps, devDeps), dep) => {
      switch dep {
      /* This doesn't cover the case where there's an OR that has "test" on each side */
      | Option(_, value, [Ident(_, "test" | "build")]) => (deps, [`Opam(value), ...devDeps])
      | _ => ([`Opam(dep), ...deps], devDeps);
      };
    },
    ([], []),
    deps
  );
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
