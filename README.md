# Test of cleaned paths and restricted mode in Nix 

This is a small experiment that demonstrates an issue with flake's restricted mode.

## Related issues

- https://github.com/NixOS/nix/issues/3732
- https://github.com/NixOS/nix/issues/3234

## Structure and usage

This project contains legacy and flake implementation of building simple hello project.
To run flake build, use `nix build .#<Type>` and to run legacy build, use `nix build -f ./default.nix --argstr type "<Type>"`.

There is also `test.sh` script which runs all builds automatically.

## Available `Type`s of builds

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

## Fixing PR

It seems like [Tomberek's PR](https://github.com/NixOS/nix/pull/5163) fixes this issue.

```
$ nix shell "github:tomberek/nix/flakes_filterSource"
$ sh test.sh 
```

Does not produce any errors.
