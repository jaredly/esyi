open Shared;

let solve = (config, manifest) => {
  SolveUtils.checkRepositories(config);
  let cache = SolveDeps.initCache(config);
  let depsByKind = Manifest.getDeps(manifest);

  let solvedDeps = SolveDeps.solveDepsForLockfile(cache, depsByKind.runtime);

  /** TODO should targets be determined completely separately?
   * seems like we'll want to be able to ~fetch~  independently...
   * but maybe solve all at once?
   * yeah probably. makes things a little harder for me.
   */
  /*
  let solvedTargets = targets |> List.map(target => {
    let targetDeps = SolveDeps.solveWithAsMuchOverlapAsPossible(
      ~cache,
      ~requested=target.dependencies.runtime,
      ~current=solvedDeps
    );
    (target, targetDeps)
  });
  */

  let getBuildDeps = List.map(d => d.Lockfile.SolvedDep.requestedDeps.build);

  let allNeededBuildDeps = solvedDeps |> getBuildDeps |> List.concat;
  /* let allNeededBuildDeps = allNeededBuildDeps @ (
    solvedTargets |> List.map(((_, deps)) => getBuildDeps(deps)) |> List.concat |> List.concat
  ); */

  ()
};
