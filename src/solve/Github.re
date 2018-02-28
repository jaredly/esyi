
open Shared.Infix;

let githubFileUrl = (user, repo, ref, file) => {
  "https://raw.githubusercontent.com/" ++ user ++"/" ++ repo ++ "/" ++ (ref |? "master") ++ "/" ++ file
};

let getManifest = (name, user, repo, ref) => {
  let esyJson = Shared.Wget.get(githubFileUrl(user, repo, ref, "esy.json"));
  let packageJson = Shared.Wget.get(githubFileUrl(user, repo, ref, "package.json"));
  let opamFile = Shared.Wget.get(githubFileUrl(user, repo, ref, name ++ ".opam"));
  if (packageJson != "") {
    `PackageJson(Yojson.Basic.from_string(packageJson))
  } else {
    failwith("No opam parsing yet")
  }
};