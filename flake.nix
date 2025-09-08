{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    nix-colors.url = "github:misterio77/nix-colors";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks.url = "github:cachix/git-hooks.nix";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-bitcoin = {
      url = "github:fort-nix/nix-bitcoin/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    neovix = {
      url = "github:storopoli/neovix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        git-hooks.follows = "git-hooks";
        flake-parts.follows = "flake-parts";
      };
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
          homeManager = false;

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

        desktop = libx.mkNixos {
          hostname = "desktop";
          username = "user";
          gnome = false;
          hyprland = true;
          homeManager = true;
          nvidia = true;
          audio = true;
          bluetooth = true;
          virtualisation = true;
          doas = true;
          dns = true;
          airplay = true;
          gaming = true;
          extraModules = [
            inputs.lanzaboote.nixosModules.lanzaboote
          ];
        };

        # Framework Desktop
        framework = libx.mkNixos {
          hostname = "framework";
          username = "user";
          gnome = false;
          hyprland = true;
          homeManager = true;
          nvidia = false;
          amdgpu = true;
          audio = true;
          bluetooth = true;
          virtualisation = true;
          doas = true;
          dns = true;
          airplay = true;
          gaming = true;
          extraModules = [
            inputs.lanzaboote.nixosModules.lanzaboote
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
        inherit (pkgs.stdenv) isLinux;
        neovix = inputs.neovix.packages.${system}.default;
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

              # Lua
              luacheck.enable = true;

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
              neovix
              lazygit
              age
              age-plugin-yubikey
              gnupg
              nixos-rebuild
              nil
              nixd
              bash-language-server
              fish-lsp
              yaml-language-server
              taplo
              marksman
              nixfmt-rfc-style
              shfmt
              statix
            ]
            ++ self.checks.${system}.pre-commit-check.enabledPackages
            ++ pkgs.lib.optionals isLinux [
              disko
            ];
          shellHook = self.checks.${system}.pre-commit-check.shellHook + ''
            export TERM=xterm
            export EDITOR=nvim
            echo "Welcome to nix-machines devshell!"
            alias lg=lazygit
          '';
        };
      }
    );
}
