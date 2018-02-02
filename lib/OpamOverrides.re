
type opamSection = {
  url: option(string),
  checksum: option(string),
  files: list((string, string)), /* relpath, contents */
  /* patches: list((string, string)) relpath, abspath */
};

type opamPackageOverride = {
  build: option(list(list(string))),
  install: option(list(list(string))),
  dependencies: list((string, string)),
  peerDependencies: list((string, string)),
  exportedEnv: list((string, (string, string))),
  opam: option(opamSection)
};

let expectResult = (message, res) => switch res {
| Rresult.Ok(x) => x
| _ => failwith(message)
};

let rec yamlToJson = value => switch value {
| `A(items) => `List(List.map(yamlToJson, items))
| `O(items) => `Assoc(List.map(((name, value)) => (name, yamlToJson(value)), items))
| `String(s) => `String(s)
| `Float(s) => `Number(s)
| `Bool(b) => `Bool(b)
| `Null => `Null
};

let (|?>) = (a, b) => switch a { | None => None | Some(x) => b(x) };
let (|?>>) = (a, b) => switch a { | None => None | Some(x) => Some(b(x)) };
let (|?) = (a, b) => switch a { | None => b | Some(a) => a };
let (|!) = (a, b) => switch a { | None => failwith(b) | Some(a) => a };

let module ProcessJson = {

  let arr = json => switch json {
  | `List(items) => Some(items)
  | _ => None
  };
  let obj = json => switch json {
  | `Assoc(items) => Some(items)
  | _ => None
  };
  let str = json => switch json {
  | `String(str) => Some(str)
  | _ => None
  };
  let get = List.assoc_opt;
  let (|.!) = (fn, message) => opt => fn(opt) |! message;

  let parseExportedEnv = items => {
    items
    |> List.assoc_opt("exportedEnv")
    |?>> (obj |.! "exportedEnv should be an object") |?>> List.map(((name, value)) => {
      (name, switch value {
      | `String(s) => (s, "global")
      | `Assoc(items) => (
          List.assoc_opt("val", items) |?> str |! "must have val",
          List.assoc_opt("scope", items) |?> str |? "global"
        )
      | _ => failwith("env value should be a string or an object")
      })
    })
  };

  let parseCommandList = json => json
    |> (arr |.! "should be a list")
    |> List.map(items => items |> (arr |.! "should be nested list") |> List.map(str |.! "command list item should be a string"));

  let parseDependencies = json => json
    |> (obj |.! "dependencies should be an object")
    |> List.map(((name, value)) => (name, value |> str |! "dep value must be a string"));

  let parseOpam = json => {
    json
    |> (obj |.! "opam should be an object")
    |> items => {
      url: items |> get("url") |?>> (str |.! "url should be a string"),
      checksum: items |> get("checksum") |?>> (str |.! "url should be a string"),
      files: items |> get("files") |?>> (arr |.! "files must be an array") |? []
        |> List.map(obj |.! "files item must be an obj")
        |> List.map(items => (
          items |> get("name") |?>> (str |.! "name must be a str") |! "name required for files",
          items |> get("content") |?>> (str |.! "content must be a str") |! "content required for files"
        )),
    }
  };

  let process = json => {
    let items = json |> obj |! "Json must be an object";
    let attr = name => items |> List.assoc_opt(name);
    {
      build: attr("build") |?>> parseCommandList,
      install: attr("install") |?>> parseCommandList,
      dependencies: attr("dependencies") |?>> parseDependencies |? [],
      peerDependencies: attr("peerDependencies") |?>> parseDependencies |? [],
      exportedEnv: parseExportedEnv(items) |? [],
      opam: attr("opam") |?>> parseOpam
    }
  };
};

let module ParseName = {
  let stripDash = num => {
    if (num.[0] == '-') {
      String.sub(num, 1, String.length(num) - 1)
    } else {
      num
    }
  };

  let stripPrefix = (text, prefix) => {
    let tl = String.length(text);
    let pl = String.length(prefix);
    if (tl > pl && String.sub(text, 0, pl) == prefix) {
      Some(String.sub(text, pl, tl - pl))
    } else {
      None
    }
  };

  let prefixes = ["<=", ">=", "<", ">"];

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

  /* yaml https://github.com/avsm/ocaml-yaml
  this file https://github.com/esy/esy-install/blob/master/src/resolvers/exotics/opam-resolver/opam-repository-override.js
  also this one https://github.com/esy/esy-install/blob/master/src/resolvers/exotics/opam-resolver/opam-repository.js */

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
};

let tee = (fn, value) => if (fn(value)) { Some(value) } else { None };

let getContents = baseDir => {
  switch (tee(Files.isFile, Filename.concat(baseDir, "package.json"))) {
  | Some(name) => ProcessJson.process(Yojson.Basic.from_file(name))
  | None => Filename.concat(baseDir, "package.yaml") |> tee(Files.isFile) |! "must have either package.json or package.yaml" |> name => ProcessJson.process(Yaml.of_string(name) |> expectResult("Bad yaml file") |> yamlToJson)
  }
};

let getOverrides = (checkoutDir) => {
  let dir = Filename.concat(checkoutDir, "packages");
  Files.readDirectory(dir) |> List.map(name => {
    let (realName, semver) = ParseName.parseDirectoryName(name);
    (realName, semver, Filename.concat(checkoutDir, name))
  })
};