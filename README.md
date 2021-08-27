# Test of cleaned paths and restricted mode in Nix 

This is a small experiment that demonstrates potential issue with flake's restricted mode.

## Structure and usage

This project contains legacy and flake implementation of building simple hello project.
To run flake build, use `nix build .#<Type>` and to run legacy build, use `nix build -f ./default.nix --argstr type "<Type>"`.

There is also `test.sh` script which runs all builds automatically.

## Avaible `Type`s of builds

There are 4 types, of builds:

- `hello-passed-src` - Simply passes `./.` folder into `hello.nix` which uses it to build derivation. Works for flake and legacy.
- `hello-passed-cleaned-src` - Passes `./.` folder cleaned with `cleanSource` and uses it to build derivation. Works for legacy, fails for flake due to restricted mode.
- `hello-not-passed-src` - Loads `./.` folder by itself and uses it to build derivation. Works for flake and legacy.
- `hello-not-passed-cleaned-src` - Loads `./.` folder by itself, cleans it with `cleanSource` and uses it to build derivation. Works for legacy, fails for flake due to restricted mode.

## Dump of `test.sh` which shows above statements

```
Current type: hello-passed-src
Legacy:
Hello World !

Flake:
Hello World !

Current type: hello-passed-cleaned-src
Legacy:
Hello World !

Flake:
error: access to path '/nix/store/4p7vhys75r7bv8dl9lhfcvgxk01jh704-source/test.txt' is forbidden in restricted mode
(use '--show-trace' to show detailed location information)

Current type: hello-not-passed-src
Legacy:
Hello World !

Flake:
Hello World !

Current type: hello-not-passed-cleaned-src
Legacy:
Hello World !

Flake:
error: access to path '/nix/store/4p7vhys75r7bv8dl9lhfcvgxk01jh704-source/test.txt' is forbidden in restricted mode
(use '--show-trace' to show detailed location information)
```

## Conclusion (?)

*Or at least what I think this means*

Restricted mode seems to not know that cleaned path should be accesible to the Nix.
This happens because new, cleaned path is in different place in store and restricted mode doesn't allow acccesing it.

I think that this happens because `NIX_PATH` is updated when building mkDerivation (based on src, buildInputs, etc), but creating arguments to it requires accesing paths that were not yet added to `NIX_PATH`.

This doesn't seem like expected behavior and I am not sure what is the workaround.
