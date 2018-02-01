
[@deriving yojson]
type versionNumber = (int, int, int, option(string));

let parsePatch = value => {
  try(switch (String.split_on_char('-', value)) {
  | [single] => switch (String.split_on_char('+', value)) {
    | [single] => switch (String.split_on_char('~', value)) {
      | [single] => (int_of_string(single), None)
      | [single, ...rest] => (int_of_string(single), Some(String.concat("~", rest)))
      | _ => (0, Some(value))
      }
    | [single, ...rest] => (int_of_string(single), Some(String.concat("+", rest)))
    | _ => (0, Some(value))
    }
  | [single, ...rest] => (int_of_string(single), Some(String.concat("-", rest)))
  | _ => (0, Some(value))
  }) {
    | _ => (0, Some(value))
  }
};

let viewVersionNumber = ((m, i, p, r)) => {
  let base = string_of_int(m) ++ "." ++ string_of_int(i) ++ "." ++ string_of_int(p);
  switch r {
  | None => base
  | Some(e) => base ++ "-" ++ e
  }
};

let parseThreeParts = (major, minor, patch) => {
  let (patch, rest) = parsePatch(patch);
  (int_of_string(major), int_of_string(minor), patch, rest)
};

let handleVersionNumberParts = parts => switch parts {
  | [major, minor, patch] => parseThreeParts(major, minor, patch)
  | [major, minor] => {
    let (minor, rest) = parsePatch(minor);
    (int_of_string(major), minor, 0, rest)
  }
  | [major] => {
    let (major, rest) = parsePatch(major);
    (major, 0, 0, rest)
  }
  | _ => failwith("expected literal versionNumber: " ++ String.concat(".", parts))
};

let versionNumberNumber = value => {
  handleVersionNumberParts (String.split_on_char('.', value))
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

let compareVersionNumbers = ((ma, ia, pa, ra), (mb, ib, pb, rb)) => {
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
