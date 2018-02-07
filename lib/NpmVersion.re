
open NpmTypes;

[@deriving yojson]
type range = GenericVersion.range(concrete);

let rawToConcrete = (raw: raw): concrete => {
  switch raw {
  | `Exactly(c) => c
  | `UpToMinor(c) => c
  | `UpToMajor(c) => c
  | _ => failwith("Invalid range")
  }
};

let rec rawToRange = (raw: raw): range => {
  open GenericVersion;
  switch raw {
  | `Or(a, b) => Or(rawToRange(a), rawToRange(b))
  | `And(a, b) => And(rawToRange(a), rawToRange(b))
  | `Between(a, b) => And(AtLeast(rawToConcrete(a)), LessThan(rawToConcrete(b)))
  | `LessThan(c) => LessThan(rawToConcrete(c))
  | `GreaterThan(c) => LessThan(rawToConcrete(c))
  | `AtMost(c) => AtMost(rawToConcrete(c))
  | `AtLeast(c) => AtLeast(rawToConcrete(c))
  | `Exactly(c) => Exactly(c)
  /* TODO the rules here are more complicated. see https://docs.npmjs.com/misc/semver */
  | `UpToMinor((m, i, p, r)) => And(AtLeast((m, i, p, r)), LessThan((m, i + 1, 0, None)))
  | `UpToMajor((m, i, p, r)) => And(AtLeast((m, i, p, r)), LessThan((m + 1, 0, 0, None)))
  | `Any => Any
  }
};

let parser = NpmParser.prog(NpmLexer.token);

let parseRange = version => {
  try (rawToRange(parser(Lexing.from_string(version)))) {
  | _ => {
    print_endline("Invalid version! pretending its any: " ++ version);
    Any
  }
  }
};

let isint = v => try ({ignore(int_of_string(v)); true}) { | _ => false };

let getRest = parts => parts == [] ? None : Some(String.concat(".", parts));

let parseConcrete = version => {
  let parts = String.split_on_char('.', version);
  switch parts {
  | [major, minor, patch, ...rest] when isint(major) && isint(minor) && isint(patch) =>
    (int_of_string(major), int_of_string(minor), int_of_string(patch), getRest(rest))
  | [major, minor, ...rest] when isint(major) && isint(minor) =>
    (int_of_string(major), int_of_string(minor), 0, getRest(rest))
  | [major, ...rest] when isint(major) =>
    (int_of_string(major), 0, 0, getRest(rest))
  | rest =>
    (0, 0, 0, getRest(rest))
  }
};

let after = (a, prefix) => {
  let al = String.length(a);
  let pl = String.length(prefix);
  if (al > pl && String.sub(a, 0, pl) == prefix) {
    Some(String.sub(a, pl, al - pl))
  } else {
    None
  }
};

let compareExtra = (a, b) => {
  switch (a, b) {
  | (Some(a), Some(b)) => {
    switch (after(a, "beta"), after(b, "beta")) {
    | (Some(a), Some(b)) => try(int_of_string(a) - int_of_string(b)) { | _ => compare(a, b) }
    | _ => switch (after(a, "alpha"), after(b, "alpha")) {
      | (Some(a), Some(b)) => try(int_of_string(a) - int_of_string(b)) { | _ => compare(a, b) }
      | _ => try(int_of_string(a) - int_of_string(b)) { | _ => compare(a, b) }
      }
    }
  }
  | _ => compare(a, b)
  }
};

let compare = ((ma, ia, pa, ra), (mb, ib, pb, rb)) => {
  ma != mb
  ? (ma - mb)
  : (
    ia != ib
    ? (ia - ib)
    : (
      pa != pb
      ? (pa - pb)
      : compareExtra(ra, rb)
    )
  )
};

let matches = GenericVersion.matches(compare);

let viewConcrete = ((m, i, p, r)) => {
  ([m, i, p] |> List.map(string_of_int) |> String.concat("."))
  ++
  switch r { | None => "" | Some(a) => a}
};

let viewRange = GenericVersion.view(viewConcrete);