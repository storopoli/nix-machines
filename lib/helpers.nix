# lib/helper.nix
{
  inputs,
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
      stateVersion ? "25.05",
      extraModules ? [ ],
      disks ? [ "/dev/sda" ],
    }:

    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

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
      ++ extraModules;
    };
}
