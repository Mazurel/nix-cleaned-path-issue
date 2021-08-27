{ pkgs ? import <nixpkgs> { }, type ? "" }:

assert (builtins.match "hello-(not-)?passed(-cleaned)?-src" type) != null;

let
  version = "xyz";

  types = {
    hello-passed-src = pkgs.callPackage ./hello.nix {
      inherit version;
      hello-folder-src = ./.;
    };
    hello-not-passed-src = pkgs.callPackage ./hello.nix {
      inherit version;
      clean = false;
    };
    hello-passed-cleaned-src = pkgs.callPackage ./hello.nix {
      inherit version;
      hello-folder-src = pkgs.lib.cleanSource ./.;
    };
    hello-not-passed-cleaned-src = pkgs.callPackage ./hello.nix {
      inherit version;
      clean = true;
    };
  };
in types."${type}"
