
open Types;

let parsePatch = value => {
  try(switch (String.split_on_char('-', value)) {
  | [single] => switch (String.split_on_char('+', value)) {
    | [single] => switch (String.split_on_char('~', value)) {
      | [single] => (int_of_string(single), None)
      | [single, ...rest] => (int_of_string(single), Some(String.concat("~", rest)))
      | _ => (0, Some(value))
      }
    /* | [single] => (int_of_string(single), None) */
    | [single, ...rest] => (int_of_string(single), Some(String.concat("+", rest)))
    | _ => (0, Some(value))
    }
  | [single, ...rest] => (int_of_string(single), Some(String.concat("-", rest)))
  | _ => (0, Some(value))
  }) {
    | _ => (0, Some(value))
  }
};

let matches = ((major, minor, patch, extra), semver) => {
  switch semver {
  | Any => true
  | Exactly((m, i, p, e)) => m == major && i == minor && p == patch && e == extra
  | UpToMinor((m, i, p, e)) => m == major && i == minor && ((p == patch && e == extra) || p <= patch)
  | UpToMajor((m, i, p, e)) => m == major && ((i == minor && p == patch && e == extra) || i <= minor)
  | AtLeast((m, i, p, e)) =>
    (
      m < major ||
      (m == major && (
        i < minor || (
          i == minor && (
            p < patch || (
              p == patch && e == extra
            )
          )
        )
      ))
    )
  /* (m == major && i == minor && p == patch && e == extra) */
  /* | AtMost((m, i, p, e)) => (m == major && i == minor && p == patch && e == extra)
  | GreaterThan((m, i, p, e)) => (m == major && i == minor && p == patch && e == extra)
  | LessThan((m, i, p, e)) => (m == major && i == minor && p == patch && e == extra) */
  }
};

/* NOTE this is not actually a triple hahah */
let triple = (major, minor, patch) => {
  let (patch, rest) = parsePatch(patch);
  (int_of_string(major), int_of_string(minor), patch, rest)
};

let handleTripleParts = parts => switch parts {
  | [major, minor, patch] => triple(major, minor, patch)
  | [major, minor] => {
    let (minor, rest) = parsePatch(minor);
    (int_of_string(major), minor, 0, rest)
  }
  | [major] => {
    let (major, rest) = parsePatch(major);
    (major, 0, 0, rest)
  }
  | _ => failwith("expected literal triple: " ++ String.concat(".", parts))
};

let tripleNumber = value => {
  handleTripleParts (String.split_on_char('.', value))
};

let parseTriple = value => {
  try {
  if (value.[0] == '~') {
    UpToMinor(tripleNumber(String.sub(value, 1, String.length(value) - 1)))
  } else if (value.[0] == '^') {
    UpToMajor(tripleNumber(String.sub(value, 1, String.length(value) - 1)))
  } else
  switch (String.split_on_char('.', value)) {
  | ["*"] => Any
  | [major]
  | [major, "*"] => UpToMajor((int_of_string(major), 0, 0, None))
  | [major, minor] => {
    let (minor, rest) = parsePatch(minor);
    UpToMinor((int_of_string(major), minor, 0, rest))
  }
  | [major, minor, "*"] => UpToMinor((int_of_string(major), int_of_string(minor), 0, None))
  | [major, minor, patch] => Exactly(triple(major, minor, patch))
  | _ => failwith("Invalid triple: " ++ value)
  }
  } {
    | _ => failwith("Failed to parse " ++ value)
  }
};
