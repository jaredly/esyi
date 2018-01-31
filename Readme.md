# Esy Install

But in ocaml this time

## Want to solve...

First, crawl all of the packages. Get from the registry.
Github things can fetch the package.json straight.

> Start at root.
> build up a potential solution
> *track js deps separately* because they have different rules
> "dependencies" is for normal (reason) dependencies
> "jsDependencies" is for things that you also want installed, but they are normal js-land deps
>   so they can have conflicts just fine
> esy_modules
> build_modules

What if I did something simple as a first pass, and then went to a SAT solver if it was hard?
- might cause weird behavior when crossing that threshhold.

```
toplevel/
    dependencies/
        esy (normal reason dependencies)
            minimist.re
            yojson
                build
                    jbuilder (buut this can be deduped with /build)
        build (buildtime only, host arch)
            jbuilder
        target_ios (dependencies for ios! resolved separately)
            some_ios_lib
```

---

Might need to split out `devBuildDeps` from `devDeps`, so that devDeps can be linkTime.
Orrr maybe just ditch devDeps entirely, and support an `esy.dev.json`, which `esy i` picks
up for you.

---



"Simplest case"
- take the latest allowed of everything
- got to distinguish



---



Using CUDF & mccs for reason deps

- for manual overrides, I just replace any dep that anyone has with that override



For js deps, I'll do a first pass where I try it with CUDF. If it proves impossible, then fall back to something dumb...
maybe where I loop through to find all conflicts?
and when I find one, remove it, treat it separately