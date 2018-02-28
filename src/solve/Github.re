
open Shared.Infix;

let githubFileUrl = (user, repo, ref, file) => {
  "https://raw.githubusercontent.com/" ++ user ++"/" ++ repo ++ "/" ++ (ref |? "master") ++ "/" ++ file
};

let getManifest = (name, user, repo, ref) => {
  let esyJson = Shared.Wget.get(githubFileUrl(user, repo, ref, "esy.json"));
  if (esyJson != "") {
    `PackageJson(Yojson.Basic.from_string(esyJson))
  } else {
    let packageJson = Shared.Wget.get(githubFileUrl(user, repo, ref, "package.json"));
    if (packageJson != "") {
      `PackageJson(Yojson.Basic.from_string(packageJson))
    } else {
      let opamFile = Shared.Wget.get(githubFileUrl(user, repo, ref, name ++ ".opam"));
      if (opamFile != "") {
        failwith("No opam parsing yet for github repos")
      } else {
        let opamFile = Shared.Wget.get(githubFileUrl(user, repo, ref, "opam"));
        if (opamFile != "") {
          failwith("No opam parsing yet for github repos")
        } else {
          failwith("No manifest found in github repo")
        }
      }
    }
  }
};