{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    flake-utils.url = "github:numtide/flake-utils";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks.url = "github:cachix/git-hooks.nix";

    nix-bitcoin = {
      url = "github:fort-nix/nix-bitcoin/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
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
        };

        matrix = libx.mkNixos {
          hostname = "matrix";
          username = "user";
        };

        git = libx.mkNixos {
          hostname = "git";
          username = "user";
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
        inherit (pkgs.stdenv) isLinux;
      in
      {
        checks = {
          pre-commit-check = inputs.git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              # Nix
              # TODO: change to nixfmt-tree when git-hooks supports it
              nixfmt-rfc-style = {
                enable = true;
                package = pkgs.nixfmt-tree;
                entry = "${pkgs.nixfmt-tree}/bin/treefmt";
              };
              statix.enable = true;
              flake-checker = {
                enable = true;
                args = [
                  "--check-outdated"
                  "false" # don't check for nixpkgs
                ];
              };

              # Tin-foil hat
              zizmor.enable = true;
            };
          };
        };
        formatter = pkgs.nixfmt-tree;

        devShells.default = pkgs.mkShell {
          buildInputs =
            with pkgs;
            [
              git
              just
              vim
              lazygit
              mkpasswd
              nixos-rebuild
            ]
            ++ self.checks.${system}.pre-commit-check.enabledPackages
            ++ pkgs.lib.optionals isLinux [
              disko
            ];
          shellHook = self.checks.${system}.pre-commit-check.shellHook + ''
            export TERM=xterm
            export EDITOR=vim
            echo "Welcome to nix-machines devshell!"
            alias lg=lazygit
            alias vi=vim
          '';
        };
      }
    );
}
