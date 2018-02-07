
[@deriving yojson]
type depSource =
  | Npm(NpmVersion.range)
  | Github(string) /* maybe cover auth here, maybe subdir support */
  | Opam(OpamVersion.range) /* opam allows a bunch of weird stuff. for now I'm just doing semver */
  | Git(string)
  ;

let resolvedPrefix = "esyi2-";

[@deriving yojson]
type dep = (string, depSource);

let viewReq = req => switch req {
| Github(s) => "github: " ++ s
| Git(s) => "git: " ++ s
| Npm(t) => "npm: " ++ NpmVersion.viewRange(t)
| Opam(t) => "opam: " ++ OpamVersion.viewRange(t)
};

type config = {
  esyOpamOverrides: string,
  opamRepository: string
};