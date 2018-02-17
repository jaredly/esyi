
[@deriving yojson]
type npmConcrete = (int, int, int, option(string));

[@deriving yojson]
type alpha = Alpha(string, option(num))
and num = Num(int, option(alpha));

module PendingSource = {
  [@deriving yojson]
  type t =
    /* url & checksum */
    | Archive(string, option(string))
    /* url & commit */
    | GitSource(string, option(string))
    | NoSource;
};

/** Lock that down */
module Source = {
  [@deriving yojson]
  type t =
    /* url & checksum */
    | Archive(string, string)
    /* url & commit */
    | GitSource(string, string)
    | NoSource;
};

[@deriving yojson]
type opamConcrete = alpha;

[@deriving yojson]
type opamRange = GenericVersion.range(opamConcrete);
[@deriving yojson]
type npmRange = GenericVersion.range(npmConcrete);

let viewNpmConcrete = ((m, i, p, r)) => {
  ([m, i, p] |> List.map(string_of_int) |> String.concat("."))
  ++
  switch r { | None => "" | Some(a) => a}
};

let rec viewOpamConcrete = (Alpha(a, na)) => {
  switch na {
  | None => a
  | Some(b) => a ++ viewNum(b)
  }
} and viewNum = (Num(a, na)) => {
  string_of_int(a) ++ switch na {
  | None => ""
  | Some(a) => viewOpamConcrete(a)
  }
};

[@deriving yojson]
type depSource =
  | Npm(GenericVersion.range(npmConcrete))
  | Github(string) /* maybe cover auth here, maybe subdir support */
  | Opam(GenericVersion.range(opamConcrete)) /* opam allows a bunch of weird stuff. for now I'm just doing semver */
  | Git(string)
  ;

let resolvedPrefix = "esyi2-";

[@deriving yojson]
type dep = (string, depSource);

let viewReq = req => switch req {
| Github(s) => "github: " ++ s
| Git(s) => "git: " ++ s
| Npm(t) => "npm: " ++ GenericVersion.view(viewNpmConcrete, t)
| Opam(t) => "opam: " ++ GenericVersion.view(viewOpamConcrete, t)
};

type config = {
  esyOpamOverrides: string,
  opamRepository: string
};


let opamFromNpmConcrete = ((major, minor, patch, rest)) => {
  Alpha("",
    Some(
      Num(major, Some(Alpha(".", Some(
        Num(minor, Some(Alpha(".", Some(
          Num(patch, switch rest {
          | None => None
          | Some(rest) => Some(Alpha(rest, None))
          })
        ))))
      ))))
    )
  )
};
