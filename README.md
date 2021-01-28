[![.github/workflows/ci.yml](https://github.com/shnewto/lilac/workflows/.github/workflows/ci.yml/badge.svg)](https://github.com/shnewto/lilac/actions)

# lilac

A library exposing symbols to read YAML from a path, to unpack that YAML into parts, and ultimately to construct some objects for repurposing.

## Summary

lilac currently has a pretty narrow scope. The `read_config` symbol takes a string file path and creates a `Yaml.value`. If you just need a data structure and a few convenience functions to juggle YAML yourself, this will do the trick! (though it'd likely be much more straight forward to just install the `yaml` package and make the call to `Yaml_unix.of_file_exn Fpath.(v path)` yourself and decide where you do and don't want `option` types haha).

The `create_config` symbol is really where the scope narrows to a particular use case. It takes a `Yaml.value` (returned by `read_config`) and creates a couple data structures.

There's an example YAML file in this repo's [test/res/](https://github.com/shnewto/lilac/tree/main/test/res) directory, but the shape of YAML the meat of the lib is looking for is this:

```
lilac-params:
  source:
    url:
    user:
    cred:
  dest:
    url:
    user:
    cred:
```

From that file, these data structures are generated for use. For examples of their usage, check out either [the tests](https://github.com/shnewto/lilac/blob/main/test/lilac_tests.ml) (most straight forward in my opinion), or the debugging logic in the [lilacbin.ml](https://github.com/shnewto/lilac/blob/main/bin/lilacbin.ml) CLI app.

```
type 'a target = {
    url: string option;
    user: string option;
    cred: string option;
}

type 'a config = {
    source: 'a target option;
    dest: 'a target option;
}
```

The `lilacbin` app in this repo's `bin/` is mostly for debugging currently. It does have some niceties like a `--help` flag, but if there's something you're interested in it doing beyond debugging, let me know! Raising an issue is my preferred channel for that kinda thing.

## Dependencies

I'll start with the basics for macOS because putting this project together required I learn them too. I hope they'll
serve as at least some direction for other operating systems but if you notice something important I've missed,
please create an issue :heart:

First you'll need `opam` and `ocaml`. For macOS:

- `brew install opam`
- `brew install ocaml`

For anything else, the opam installation docs live [here](https://opam.ocaml.org/doc/Install.html),
and the ocaml intallation docs live [here](https://ocaml.org/docs/install.html).

Once OCaml and opam are installed, run `opam init` from the terminal to get the environment sorted. I chose to
let it modify my terminal's rc file (`.zshrc`) so I wouldn't have to think about it again, but that's up to you :)
## Installing

If you just want to install lilac as a library and use it in your application, you can run `opam install lilac`.
Otherwise, see the Developing section below.

## Developing
## Dev dependencies

For local development, I'll recommend not installing with opam beforehand. Once you've cloned the repo and have naviated into its directory, you'll want to run these commands, in this order:

- `opam pin .`
- `opam install . --deps-only`

## Building

`make`

## Running the test

`make test`

## Running lilac bin for stdout debugging / validation

`make run args='-i <path to yaml file>'`

For example `make run args='-i test/res/config.yaml'`
