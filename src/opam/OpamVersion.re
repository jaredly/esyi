
/* [@deriving yojson]
type alpha = Alpha(string, option(num))
and num = Num(int, option(alpha));

[@deriving yojson]
type concrete = alpha;

[@deriving yojson]
type range = Shared.GenericVersion.range(concrete); */

open Shared.Types;

let parseConcrete = Npm.OpamConcrete.parseConcrete;
let triple = Npm.OpamConcrete.triple;

let fromPrefix = (op, version) => {
  open Shared.GenericVersion;
  let v = parseConcrete(version);
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
  open OpamParserTypes;
  open Shared.GenericVersion;
  switch opamvalue {
  | Prefix_relop(_, op, String(_, version)) => fromPrefix(op, version)
  | Logop(_, `And, left, right) => {
    And(parseRange(left), parseRange(right))
  }
  | Logop(_, `Or, left, right) => Or(parseRange(left), parseRange(right))
  | String(_, version) => Exactly(parseConcrete(version))
  | Option(_, contents, options) => {
    print_endline("Ignoring option: " ++ (options |> List.map(OpamPrinter.value) |> String.concat(" .. ")));
    parseRange(contents)
  }
  | y => {
    print_endline("Unexpected option -- pretending its any " ++
    OpamPrinter.value(opamvalue));
    Any
  }
  }
};

let rec toDep = opamvalue => {
  open OpamParserTypes;
  open Shared.GenericVersion;
  switch opamvalue {
  | String(_, name) => (name, Any, `Link)
  | Option(_, String(_, name), [Ident(_, "build")]) => (name, Any, `Build)
  | Option(_, String(_, name), [Logop(_, `And, Ident(_, "build"), version)]) => (name, parseRange(version), `Build)
  | Option(_, String(_, name), [Ident(_, "test")]) => (name, Any, `Test)
  | Option(_, String(_, name), [Logop(_, `And, Ident(_, "test"), version)]) => (name, parseRange(version), `Test)
  | Group(_, [Logop(_, `Or, String(_, "base-no-ppx"), otherThing)]) => {
    /* yep we allow ppxs */
    toDep(otherThing)
  }
  | Group(_, [Logop(_, `Or, String(_, one), String(_, two))]) => {
    print_endline("Arbitrarily choosing the second of two options: " ++ one ++ " and " ++ two);
    (two, Any, `Link)
  }
  | Group(_, [Logop(_, `Or, first, second)]) => {
    print_endline("Arbitrarily choosing the first of two options: " ++ OpamPrinter.value(first) ++ " and " ++ OpamPrinter.value(second));
    toDep(first)
  }
  | Option(_, String(_, name), [option]) => {
    (name, parseRange(option), `Link)
  }
  | _ => {
    failwith("Can't parse this opam dep " ++ OpamPrinter.value(opamvalue))
  }
  };
};

let rec compare = (Alpha(a, na), Alpha(b, nb)) => {
  if (a == b) {
    switch (na, nb) {
    | (None, None) => 0
    | (None, _) => -1
    | (_, None) => 1
    | (Some(na), Some(nb)) => compareNums(na, nb)
    }
  } else {
    /** TODO include the rule where "~" is sorted before the empty (none) string */
    Pervasives.compare(a, b)
  }
} and compareNums = (Num(a, aa), Num(b, ab)) => {
  if (a == b) {
    switch (aa, ab) {
    | (None, None) => 0
    | (None, _) => -1
    | (_, None) => 1
    | (Some(aa), Some(ab)) => compare(aa, ab)
    }
  } else {
    a - b
  }
};

let rec viewAlpha = (Alpha(a, na)) => {
  switch na {
  | None => a
  | Some(b) => a ++ viewNum(b)
  }
} and viewNum = (Num(a, na)) => {
  string_of_int(a) ++ switch na {
  | None => ""
  | Some(a) => viewAlpha(a)
  }
};

let matches = Shared.GenericVersion.matches(compare);

let viewRange = Shared.GenericVersion.view(viewAlpha);