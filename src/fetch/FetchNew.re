
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

  let nodeModules = basedir /+ "node_modules";
  Shared.Files.removeDeep(nodeModules);
  Shared.Files.mkdirp(nodeModules);

  Hashtbl.iter(((name, version), source) => {
    let dest = modcache /+ FetchUtils.absname(name, version);
    FetchUtils.unpackArchive(dest, cache, name, version, source);
    let nmDest = nodeModules /+ name;
    if (Shared.Files.exists(nmDest)) {
      failwith("Duplicate modules")
    };
    Shared.Files.mkdirp(Filename.dirname(nmDest));
    Shared.Files.symlink(dest, nmDest);
  }, packagesToFetch);

};
