{
  description = "An over-engineered Hello World in bash";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      version = "xyz";

      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      nixpkgsFor = forAllSystems
        (system: import nixpkgs
          {
            inherit system;
            overlays = [ self.overlay ];
          });
    in
    {
      overlay = final: prev: {
        hello-passed-src = final.callPackage ./hello.nix {
          inherit version;
          hello-folder-src = ./.;
        };

        hello-not-passed-src = final.callPackage ./hello.nix {
          inherit version;
          clean = false;
        };

        hello-passed-cleaned-src = final.callPackage ./hello.nix {
          inherit version;
          hello-folder-src = final.lib.cleanSource ./.;
        };

        hello-not-passed-cleaned-src = final.callPackage ./hello.nix {
          inherit version;
          clean = true;
        };
      };

      packages = forAllSystems (system:
        {
          inherit (nixpkgsFor.${system})
            # Working:
            hello-passed-src
            # Not working:
            hello-not-passed-src hello-passed-cleaned-src hello-not-passed-cleaned-src;
        });
    };
}
