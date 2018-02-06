
type alpha = Alpha(string, option(num))
and num = Num(int, option(alpha));

type concrete = alpha;

type range = GenericVersion.range(concrete);

let rec getNums = (text, pos) => {
  if (pos < String.length(text)) {
    switch (text.[pos]) {
    | '0'..'9' => getNums(text, pos + 1)
    | _ => pos
    }
  } else {
    pos
  }
};

let rec getNonNums = (text, pos) => {
  if (pos < String.length(text)) {
    switch (text.[pos]) {
    | '0'..'9' => pos
    | _ => getNonNums(text, pos + 1)
    }
  } else {
    pos
  }
};

let parseConcrete = text => {
  let len = String.length(text);
  let rec getNum = (pos) => {
    if (pos >= len) {
      None
    } else {
      let tpos = getNums(text, pos);
      let num = String.sub(text, pos, tpos - pos);
      Some(Num(int_of_string(num), getString(tpos)))
    }
  } and getString = pos => {
    if (pos >= len) {
      None
    } else switch (text.[pos]) {
    | '0'..'9' => Some(Alpha("", getNum(pos)))
    | _ => {
      let tpos = getNonNums(text, pos);
      let t = String.sub(text, pos, tpos - pos);
      Some(Alpha(t, getNum(tpos)))
    }
    }
  };
  getString(0)
};

let fromPrefix = (op, version) => {
  open GenericVersion;
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
  open GenericVersion;
  switch opamvalue {
  | Prefix_relop(_, op, String(_, version)) => fromPrefix(op, version)
  | Logop(_, `And, left, right) => And(parseRange(left), parseRange(right))
  | Logop(_, `Or, left, right) => Or(parseRange(left), parseRange(right))
  | String(_, version) => Exactly(parseConcrete(version))
  | y => {
    print_endline("Unexpected option -- pretending its any " ++
    OpamPrinter.value(opamvalue));
    Any
  }
  }
};

let toDep = opamvalue => {
  open OpamParserTypes;
  open GenericVersion;
  let (name, s) = switch opamvalue {
  | String(_, name) => (name, Any)
  | Option(_, String(_, name), [option]) => (name, parseRange(option))
  | _ => {
    failwith("Can't parse this opam dep " ++ OpamPrinter.value(opamvalue))
  }
  };
  (name, s)
};
