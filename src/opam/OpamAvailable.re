

let parseConcrete = Npm.OpamConcrete.parseConcrete;
let triple = Npm.OpamConcrete.triple;

let fromPrefix = (op, version) => {
  open Shared.GenericVersion;
  let v = Npm.NpmVersion.parseConcrete(version);
  switch op {
  | `Eq => Exactly(v)
  | `Geq => AtLeast(v)
  | `Leq => AtMost(v)
  | `Lt => LessThan(v)
  | `Gt => GreaterThan(v)
  | `Neq => failwith("Can't do neq in opam version constraints")
  }
};

let rec parseRange = opamvalue => {
  /* Shared.GenericVersion.Any */
  open OpamParserTypes;
  open Shared.GenericVersion;
  switch opamvalue {
  | Logop(_, `And, left, right) => {
    And(parseRange(left), parseRange(right))
  }
  | Logop(_, `Or, left, right) => Or(parseRange(left), parseRange(right))
  | Relop(_, rel, Ident(_, "ocaml-version"), String(_, version)) => fromPrefix(rel, version)
  /* We don't support pre-4.02.3 anyway */
  | Relop(_, `Neq, Ident(_, "compiler"), String(_, "4.02.1+BER")) => Any
  | Relop(_, `Eq, Ident(_, "compiler"), String(_, _)) => Any
  | Relop(_, _rel, Ident(_, "opam-version"), _) => Any /* TODO should I care about this? */
  | Relop(_, rel, Ident(_, "os"), String(_, version)) => Any
  | Pfxop(_, `Not, Ident(_, "preinstalled")) => Any
  | Ident(_, "preinstalled") => Any
  | Option(_, contents, options) => {
    print_endline("Ignoring option: " ++ (options |> List.map(OpamPrinter.value) |> String.concat(" .. ")));
    parseRange(contents)
  }
  | List(_, items) => {
    let rec loop = items => switch items {
    | [] => Any
    | [item] => parseRange(item)
    | [item, ...rest] => And(parseRange(item), loop(rest))
    };
    loop(items)
  }
  | Group(_, items) => {
    let rec loop = items => switch items {
    | [] => Any
    | [item] => parseRange(item)
    | [item, ...rest] => And(parseRange(item), loop(rest))
    };
    loop(items)
  }
  | y => {
    print_endline("Unexpected option -- pretending its any " ++ OpamPrinter.value(opamvalue));
    Any
  }
  }
};
