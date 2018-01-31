
open Types;

let tripleNumber = value => {
  switch (String.split_on_char('.', value)) {
  | [major, minor, patch] => (int_of_string(major), int_of_string(minor), int_of_string(patch))
  | _ => failwith("ex[ected literal triple: " ++ value)
  }
};

let parseTriple = value => {
  if (value.[0] == '~') {
    UpToMinor(tripleNumber(value))
  } else if (value.[0] == '^') {
    UpToMajor(tripleNumber(value))
  } else
  switch (String.split_on_char('.', value)) {
  | ["*"] => Any
  | [major]
  | [major, "*"] => UpToMajor((int_of_string(major), 0, 0))
  | [major, minor]
  | [major, minor, "*"] => UpToMinor((int_of_string(major), int_of_string(minor), 0))
  | [major, minor, patch] => Exactly((int_of_string(major), int_of_string(minor), int_of_string(patch)))
  | _ => failwith("Invalid triple: " ++ value)
  }
};
