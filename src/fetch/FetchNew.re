
let (/+) = Filename.concat;

let fetch = (basedir, env) => {
  open Shared.Env;
  let packagesToFetch = Hashtbl.create(100);
  let addPackage = ({name, version, source}) => Hashtbl.replace(packagesToFetch, (name, version), source);
  env.targets |> List.iter(((_, {runtimeBag})) => runtimeBag |> List.iter(addPackage));
  env.buildDependencies |> List.iter(({package, runtimeBag}) => {
    addPackage(package);
    List.iter(addPackage, runtimeBag)
  });

  let cache = basedir /+ ".esy-cache-new" /+ "archives";
  Shared.Files.mkdirp(cache);
  let modcache = basedir /+ ".esy-modules-new";

  Hashtbl.iter(((name, version), source) => {
    let dest = modcache /+ FetchUtils.absname(name, version);
    FetchUtils.unpackArchive(dest, cache, name, version, source)
  }, packagesToFetch)
};
