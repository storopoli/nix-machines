{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-bitcoin = {
      url = "github:fort-nix/nix-bitcoin/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };
    continuwuity = {
      url = "git+https://forgejo.ellis.link/continuwuation/continuwuity";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Caches
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.iog.io"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
  };

  outputs =
    { self, ... }@inputs:
    let
      libx = import ./lib { inherit inputs; };
    in
    {
      # Define nixosConfigurations before calling "eachDefaultSystem" from flake-utils;
      #
      # https://www.reddit.com/r/NixOS/comments/12aykwj/comment/jev7ghc
      nixosConfigurations = {
        bitcoin = libx.mkNixos {
          hostname = "bitcoin";
          username = "user";

          extraModules = [
            inputs.nix-bitcoin.nixosModules.default
            inputs.disko.nixosModules.disko

            (inputs.nix-bitcoin + "/modules/presets/secure-node.nix")
          ];
        };

        monero = libx.mkNixos {
          hostname = "monero";
          username = "user";
          extraModules = [
            inputs.disko.nixosModules.disko
          ];
        };

        matrix = libx.mkNixos {
          hostname = "matrix";
          username = "user";
          extraModules = [
            inputs.disko.nixosModules.disko
          ];
        };

        git = libx.mkNixos {
          hostname = "git";
          username = "user";
          extraModules = [
            inputs.disko.nixosModules.disko
          ];
        };

        desktop = libx.mkNixos {
          hostname = "desktop";
          username = "user";
          extraModules = [
            inputs.disko.nixosModules.disko
            inputs.home-manager.nixosModules.home-manager
          ];
        };
      };

      darwinConfigurations = {
        macbook = libx.mkDarwin {
          hostname = "macbook";
          username = "user";
          system = "aarch64-darwin";
        };
      };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        isLinux = pkgs.stdenv.isLinux;
      in
      {
        checks = {
          nix-sanity-check = inputs.git-hooks.lib.${system}.run {
            src = pkgs.lib.fileset.toSource {
              root = ./.;
              fileset = pkgs.lib.fileset.unions [
                ./lib
                ./hosts
                ./flake.nix
                ./flake.lock
              ];
            };
            hooks = {
              nixfmt-rfc-style.enable = true;

              flake-checker = {
                enable = true;
                args = [
                  "--check-outdated"
                  "false" # don't check for nixpkgs
                ];
              };
            };
          };
        };
        devShells.default = pkgs.mkShell {
          buildInputs =
            with pkgs;
            [
              git
              just
              pkgs-unstable.helix
              lazygit
              age
              age-plugin-yubikey
              gnupg
              nixos-rebuild
              nil
              nixfmt-rfc-style
              yaml-language-server
            ]
            ++ pkgs.lib.optionals isLinux [
              disko
            ];
          shellHook = self.checks.${system}.nix-sanity-check.shellHook + ''
            export TERM=xterm
            echo "Welcome to home-server devshell!"
            echo "Available tools:"
            echo "- git: $(git --version)"
            echo "- just: $(just --version)"
            echo "- age: $(age --version)"
            echo "- helix $(hx --version)"
            echo "- lazygit $(lazygit --version)"
            alias lg=lazygit
          '';
        };
      }
    );
}
