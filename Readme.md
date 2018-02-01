# Esy Install

But in ocaml this time. With a real solver, so we get good dependencies.

## Completed

- [x] parsing opam files & mostly converting the dependencies (I bail on the more complex boolean operations, pretending they are "any")
- [x] parsing package.json files
- [x] talking to the npm registry
- [x] looking in a local copy of the opam registry
- [x] using MCCS (a SAT solver) to find a valid assignment of dependencies!
- [x] tracking buildDependencies separately
- [x] sharing resolved buildDependencies when possible
- [x] generating a lockfile! (it's yojson at the moment, so don't expect anything fancy)
- [x] fetching all the things, with some opam -> package.json conversion

## Still to do

- [ ] opam conversion
    - [ ] incorporate `esy-opam-overrides`
    - [ ] convert opam `(>= 1.2.0 & < 1.3.0)` into `~1.2.0` (and similar)
- [ ] finish opam -> package.json conversion
- [ ] deciding what we want to do with devDependencies (I think maybe I'll lump them in with buildDependencies?)
- [ ] make the generated lockfile a nicer format (maybe yaml/toml?)
- [ ] parallelize some things, but make sure not to compromise reproducability
- [ ] maybe use a global cache for fetched things? currently using a project-local cache
- [ ] handle the not-fresh case
    - [ ] inflate from lockfile
    - [ ] check staleness
    - [ ] add/remove/upgrade deps

## Later on

- [ ] support multiple architecture targets!
