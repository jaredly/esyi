
open Types;

let parsePatch = value => {
  switch (String.split_on_char('-', value)) {
  | [single] => (int_of_string(single), None)
  | [single, rest] => (int_of_string(single), Some(rest))
  | _ => failwith("Invalid patch")
  }
};

let triple = (major, minor, patch) => {
  let (patch, rest) = parsePatch(patch);
  (int_of_string(major), int_of_string(minor), patch, rest)
};

let tripleNumber = value => {
  switch (String.split_on_char('.', value)) {
  | [major, minor, patch] => triple(major, minor, patch)
  | _ => failwith("ex[ected literal triple: " ++ value)
  }
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
  | [major, minor]
  | [major, minor, "*"] => UpToMinor((int_of_string(major), int_of_string(minor), 0, None))
  | [major, minor, patch] => Exactly(triple(major, minor, patch))
  | _ => failwith("Invalid triple: " ++ value)
  }
  } {
    | _ => failwith("Failed to parse " ++ value)
  }
};
