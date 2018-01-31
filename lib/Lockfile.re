
/**
 * esy_modules/
 *    something
 *      build_modules/
 *        something
 *          esy_modules
 *          build_modules
 *        adep
 *    otherdep
 *      build_modules/
 *        for another one
 *          esy_modules
 *          build_modules
 *    third
 * dev_modules/
 * build_modules/
 *    somebuild
 *      esy_modules
 *      build_modules
 *
 * One idea:
 * in order to cut down on duplication, I could unzip htings into the base directory
 */

type solvedDep = {
  name: string,
  version: string,
  archive: string,
  checksum: string,
}

and lockfile = {
  specifiedDeps: list(Types.dep),
  specifiedDevDeps: list(Types.dep),
  /* specifiedBuildDeps: list(Types.dep), */
  /* The dep, and its build deps */
  solvedDeps: list((solvedDep, list(solvedDep))),
  solvedDevDeps: list((solvedDep, list(solvedDep))),
  /* solvedBuildDeps: list(solvedDep), */
};
