{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
      # follows = "comity/nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      # follows = "comity/flake-utils";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
      # follows = "comity/flake-compat";
    };
  };

  description = "Callbacks for YARA rule matches";

  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    {
      overlays.default = final: prev: {
        yallback = final.callPackage ./yallback.nix {
          version = prev.yallback.version + "-" + (self.shortRev or "dirty");
          src = final.lib.cleanSource self;
        };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.default
          ];
        };
      in
        {
          packages = {
            inherit (pkgs) yallback;
            default = pkgs.yallback;
          };
          checks = pkgs.callPackages ./ci.nix {
            inherit (pkgs) yallback;
          };
          devShells = {
            default = pkgs.mkShell {
              buildInputs = [ pkgs.yallback ];
            };
          };
        }
    );
}
