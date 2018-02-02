
let stripDash = num => {
  if (num.[0] == '-') {
    String.sub(num, 1, String.length(num) - 1)
  } else {
    num
  }
};

let prefixes = ["<=", ">=", "<", ">"];

let stripPrefix = (text, prefix) => {
  let tl = String.length(text);
  let pl = String.length(prefix);
  if (tl > pl && String.sub(text, 0, pl) == prefix) {
    Some(String.sub(text, pl, tl - pl))
  } else {
    None
  }
};

let prefix = (name) => {
  let rec loop = (prefixes) => {
    switch prefixes {
    | [] => (None, name)
    | [one, ...rest] => {
      switch (stripPrefix(name, one)) {
      | None => loop(rest)
      | Some(text) => (Some(one), text)
      }
    }
    }
  };
  loop(prefixes)
};

let parseDirectoryName = (name) => {
  open Semver;
  switch (String.split_on_char('.', name)) {
  | [] => assert(false)
  | [single] => (single, Semver.Any)
  | [name, num, "x", "x" | "x-"] => {
    (name, Semver.UpToMajor((int_of_string(num), 0, 0, None)))
  }
  | [name, num, minor, "x" | "x-"] => {
    (name, Semver.UpToMinor((int_of_string(stripDash(num)), int_of_string(minor), 0, None)))
  }
  | [name, major, minor, patch] => {
    let (prefix, major) = prefix(major);
    let version = (int_of_string(major), int_of_string(minor), int_of_string(patch), None);
    (name, switch prefix {
    | None => Exactly(version)
    | Some(">") => GreaterThan(version)
    | Some(">=") => AtLeast(version)
    | Some("<" )=> LessThan(version)
    | Some("<=") => AtMost(version)
    | _ => assert(false)
    })
  }
  | _ => failwith("Bad override version " ++ name)
  }
};
