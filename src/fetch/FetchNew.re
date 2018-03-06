
let fetch = (basedir, env) => {
  open Shared.Env;
  let packagesToFetch = Hashtbl.create(100);
  let addPackage = ({name, version, source}) => Hashtbl.replace(packagesToFetch, (name, version), source);
  env.targets |> List.iter(((_, {runtimeBag})) => runtimeBag |> List.iter(addPackage));
  env.buildDependencies |> List.iter(({package, runtimeBag}) => {
    addPackage(package);
    List.iter(addPackage, runtimeBag)
  });
};
