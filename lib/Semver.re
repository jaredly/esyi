
open VersionNumber;

[@deriving yojson]
type semver =
  | Any
  | Exactly(versionNumber)
  | AtLeast(versionNumber)
  /* | GreaterThan(versionNumber)
  | AtMost(versionNumber)
  | LessThan(versionNumber) */
  | UpToMinor(versionNumber)
  | UpToMajor(versionNumber);

let matches = ((major, minor, patch, extra), semver) => {
  switch semver {
  | Any => true
  | Exactly((m, i, p, e)) => m == major && i == minor && p == patch && e == extra
  | UpToMinor((m, i, p, e)) => m == major && i == minor && ((p == patch && e == extra) || p <= patch)
  | UpToMajor((m, i, p, e)) => m == major && ((i == minor && p == patch && e == extra) || i <= minor)
  | AtLeast((m, i, p, e)) => compareVersionNumbers((m, i, p, e), (major, minor, patch, extra)) <= 0
  }
};

let viewSemver = semver => switch  semver {
  | Any => "any"
  | Exactly(t) => "exactly " ++ VersionNumber.viewVersionNumber(t)
  | UpToMajor(t) => "^" ++ VersionNumber.viewVersionNumber(t)
  | UpToMinor(t) => "~" ++ VersionNumber.viewVersionNumber(t)
  | AtLeast(t) => ">=" ++ VersionNumber.viewVersionNumber(t)
};

let parseSemver = value => {
  try {
  if (value.[0] == '~') {
    UpToMinor(versionNumberNumber(String.sub(value, 1, String.length(value) - 1)))
  } else if (value.[0] == '^') {
    UpToMajor(versionNumberNumber(String.sub(value, 1, String.length(value) - 1)))
  } else
  switch (String.split_on_char('.', value)) {
  | ["*"] => Any
  | [major] => {
    let (major, rest) = parsePatch(major);
    UpToMajor((major, 0, 0, rest))
  }
  | [major, "*"] => UpToMajor((int_of_string(major), 0, 0, None))
  | [major, minor] => {
    let (minor, rest) = parsePatch(minor);
    UpToMinor((int_of_string(major), minor, 0, rest))
  }
  | [major, minor, "*"] => UpToMinor((int_of_string(major), int_of_string(minor), 0, None))
  | [major, minor, patch] => Exactly(parseThreeParts(major, minor, patch))
  | _ => failwith("Invalid versionNumber: " ++ value)
  }
  } {
    | _ => failwith("Failed to parse " ++ value)
  }
};

