
/**
 * At this point, we've already fetched a ton of stuff probably.
 * Although maybe the lockfile also locks down we're getting this stuff from.
 * So I don't depend on any registry stuff at this point.
 */
open Lockfile;

let fetchDep = (dir, {archive, checksum}) => {
  failwith("not impl");
};

let run = (baseDir: string, lockfile: lockfile) => {
  /* List.iter(fetchDep(Filename.concat(baseDir, "esy_modules")), lockfile.solvedDeps);
  List.iter(fetchDep(Filename.concat(baseDir, "dev_modules")), lockfile.solvedDevDeps) */
};