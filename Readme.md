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
- [x] write out override files
- [x] get the files from opam too tho
- [x] handle override patches too
- [x] add a `_resolved` field
- [x] opam conversion
    - [x] incorporate `esy-opam-overrides`
- [ ] get jbuilder building

# Needed to work with current esy (get something building!)

## Needed less urgently

- [ ] have the opam peerdependency version actually matter (I ignore the version currently)
- [ ] convert opam `(>= 1.2.0 & < 1.3.0)` into `~1.2.0` (and similar)
- [ ] actually validate checksums
- [ ] deciding what we want to do with devDependencies (currently they're dumped into build dependences)
- [ ] make the generated lockfile a nicer format (maybe yaml/toml?)
- [ ] parallelize some things, but make sure not to compromise reproducability
- [ ] handle the not-fresh case
    - [ ] inflate from lockfile
    - [ ] check staleness
    - [ ] add/remove/upgrade deps

## Later on

- [ ] maybe fetch tarballs from the opam mirror directly
- [ ] maybe use a global cache for fetched things? currently using a project-local cache
- [ ] support multiple architecture targets!

This looks like... having multiple

## Currently required setup

```
g clone https://github.com/esy-ocaml/esy-opam-override ~/.esyi/esy-opam-override
g clone https://github.com/ocaml/opam-repository ~/.esyi/opam-repository --depth=1 --single-branch --branch=master
```
