# lib/helper.nix
{
  inputs,
  lib,
  ...
}:

let
  nix-colors = inputs.nix-colors;
in
{
  mkDarwin =
    {
      hostname,
      username ? "user",
      system ? "aarch64-darwin",
      extraModules ? [ ],
    }:

    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      isLinux = pkgs.stdenv.isLinux;
      isDarwin = pkgs.stdenv.isDarwin;
    in

    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          username
          ;
      };
      modules = [
        ../hosts/${hostname}
        inputs.home-manager.darwinModules.home-manager
        {
          nixpkgs.config.allowUnfree = true;
        }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ../home-manager;
          home-manager.extraSpecialArgs = {
            inherit
              inputs
              username
              isLinux
              isDarwin
              nix-colors
              ;
            gnome = false;
            hyprland = false;
          };
        }
      ]
      ++ extraModules;
    };

  mkNixos =
    {
      hostname,
      username ? "user",
      system ? "x86_64-linux",
      # This option defines the first version of NixOS you have installed on this particular machine
      # WARN: DON'T CHANGE THIS VALUE ONCE YOU SET IT
      stateVersion ? "25.05",
      extraModules ? [ ],
      disks ? [ "/dev/sda" ],
      # Desktop environments
      gnome ? false,
      hyprland ? false,
      # Hardware options
      nvidia ? false,
      audio ? false,
      bluetooth ? false,
      # Feature options
      gaming ? false,
      virtualisation ? false,
      dns ? false,
      airplay ? false,
      # Home manager integration
      homeManager ? true,
    }:

    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      isLinux = pkgs.stdenv.isLinux;
      isDarwin = pkgs.stdenv.isDarwin;

      commonExpression = import ../hosts/default.nix {
        inherit
          pkgs
          stateVersion
          inputs
          username
          ;
        module = hostname;
      };

      systemExpression = import ../hosts/${hostname} {
        inherit inputs username;
        module = hostname;
      };

      # Conditional modules based on options
      conditionalModules =
        lib.optionals gnome [ (import ./gnome.nix { inherit pkgs lib nvidia; }) ]
        ++ lib.optionals hyprland [ (import ./hyprland.nix) ]
        ++ lib.optionals nvidia [ (import ./nvidia.nix) ]
        ++ lib.optionals audio [ (import ./audio.nix) ]
        ++ lib.optionals bluetooth [ (import ./bluetooth.nix) ]
        ++ lib.optionals gaming [ (import ./gaming.nix) ]
        ++ lib.optionals virtualisation [ (import ./virtualisation.nix) ]
        ++ lib.optionals dns [ (import ./dns.nix) ]
        ++ lib.optionals airplay [ (import ./airplay.nix) ];

      # Home manager module (optional)
      homeManagerModules = lib.optionals homeManager [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ../home-manager;
          home-manager.extraSpecialArgs = {
            inherit
              inputs
              username
              isLinux
              isDarwin
              gnome
              hyprland
              nvidia
              nix-colors
              ;
          };
        }
      ];
    in

    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          system
          hostname
          username
          disks
          ;
      };
      modules = [
        {
          nixpkgs.config.allowUnfree = true;
        }
        commonExpression
        systemExpression
        (import ./tailscale.nix)
        (import ./ssh.nix)
      ]
      ++ conditionalModules
      ++ homeManagerModules
      ++ extraModules;
    };
}
