{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
    };
    nix-bitcoin = {
      url = "github:fort-nix/nix-bitcoin/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };
    continuwuity = {
      url = "git+https://forgejo.ellis.link/continuwuation/continuwuity";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      libx = import ./lib { inherit inputs; };
    in
    {
      # Define nixosConfigurations before calling "eachSystem" from flake-utils;
      #
      # https://www.reddit.com/r/NixOS/comments/12aykwj/comment/jev7ghc
      nixosConfigurations = {
        bitcoin = libx.mkNixos {
          hostname = "bitcoin";
          username = "user";

          extraModules = [
            inputs.nix-bitcoin.nixosModules.default
            inputs.sops-nix.nixosModules.sops
            inputs.disko.nixosModules.disko

            (inputs.nix-bitcoin + "/modules/presets/secure-node.nix")
          ];
        };

        monero = libx.mkNixos {
          hostname = "monero";
          username = "user";
          extraModules = [
            inputs.sops-nix.nixosModules.sops
            inputs.disko.nixosModules.disko
          ];
        };

        matrix = libx.mkNixos {
          hostname = "matrix";
          username = "user";
          extraModules = [
            inputs.sops-nix.nixosModules.sops
            inputs.disko.nixosModules.disko
          ];
        };
      };
    }
    // inputs.flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        checks = {
          nix-sanity-check = inputs.pre-commit-hooks.lib.${system}.run {
            src = pkgs.lib.fileset.toSource {
              root = ./.;
              fileset = pkgs.lib.fileset.unions [
                ./lib
                ./flake.nix
                ./flake.lock
              ];
            };
            hooks = {
              nixfmt-rfc-style = {
                enable = true;

              };
              statix = {
                enable = true;

              };
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
          buildInputs = with pkgs; [
            git
            just
            vim
            helix
            lazygit
            age
            age-plugin-yubikey
            sops
            gnupg
            nixos-rebuild
            disko
            nil
          ];
          shellHook = ''
            echo "Welcome to home-server devshell!"
            echo "Available tools:"
            echo "- git: $(git --version)"
            echo "- just: $(just --version)"
            echo "- sops: $(sops --version)"
            echo "- age: $(age --version)"
            echo "- helix $(hx --version)"
            echo "- lazygit $(lazygit --version)"
            alias lg=lazygit
          '';
        };
      }
    );
}
