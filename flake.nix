{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-bitcoin = {
      url = "github:fort-nix/nix-bitcoin/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, nix-bitcoin, sops-nix, ... }@inputs:
    let
      inherit (self) outputs;
      stateVersion = "24.11";
      libx = import ./lib { inherit inputs outputs stateVersion; };

      # Define nixosConfigurations at the top level
      nixosConfigurations = {
        bitcoin = libx.mkNixos {
          system = "x86_64-linux";
          hostname = "bitcoin";
          username = "user";
          extraModules = [
            nix-bitcoin.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        monero = libx.mkNixos {
          system = "x86_64-linux";
          hostname = "monero";
          username = "user";
          extraModules = [
            sops-nix.nixosModules.sops
          ];
        };
      };
    in {
      inherit nixosConfigurations;
    } // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          git
          just
          vim
          helix
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
          echo "- helix $(helix --version)"
        '';
      };
    });
}