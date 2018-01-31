
/**
 * build_modules/ <-- applies to whole tree!
 *    some-tool.1.1.0/
 *      src/
 *      esy_modules/
 *    other-tool.3.4.0/
 * esy_modules/
 *    something
 *      src/
 *    otherdep
 *      src/
 *    third
 *      src/
 * dev_modules/
 *    something
 *      src/
 *    otherdep
 *      src/
 *
 * Once I've solved all the other things, figure out what build deps I have, and try to cull them down
 * to deduplicate things that fit within the same semver range.
 * Then get them, and resolve deps as though they were top-level, but *sharing the same build_modules cache*.
 * This way build_modules live in a single place.
 *
 */

type solvedDep = {
  name: string,
  version: string,
  archive: string,
  checksum: string,
  unpackedLocation: string,
  buildDeps: list((string, string)),
}

and lockfile = {
  specifiedDeps: list(Types.dep),
  specifiedBuildDeps: list(Types.dep),
  /* TODO dev deps, they need to be split into devBuildDeps probably */
  /* specifiedDevDeps: list(Types.dep), */
  /* solvedDevDeps: list(solvedDep), */
  solvedDeps: list(solvedDep),
  solvedBuildDeps: list((string, string)),
  /* A mapping of name:version to the solved dependencies, and the solved build deps */
  fullBuildDeps: list((string, list(solvedDep), list((string, string)))),
};

let empty = {
  specifiedDeps: [],
  /* specifiedDevDeps: [], */
  specifiedBuildDeps: [],
  solvedDeps: [],
  /* solvedDevDeps: [], */
  solvedBuildDeps: [],
  fullBuildDeps: [],
};