
[@deriving yojson]
type depSource =
  | Npm(Semver.semver)
  | Github(string) /* maybe cover auth here, maybe subdir support */
  | Opam(Semver.semver) /* opam allows a bunch of weird stuff. for now I'm just doing semver */
  | Git(string)
  ;

[@deriving yojson]
type dep = (string, depSource);

let viewReq = req => switch req {
| Github(s) => "github: " ++ s
| Git(s) => "git: " ++ s
| Npm(t) => "npm: " ++ Semver.viewSemver(t)
| Opam(t) => "opam: " ++ Semver.viewSemver(t)
};

type config = {
  esyOpamOverrides: string,
};