# lib/helper.nix
{ inputs, ... }:
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
      pkgs-unstable = import inputs.nixpkgs-unstable {
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
          pkgs
          pkgs-unstable
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
              pkgs-unstable
              isLinux
              isDarwin
              ;
          };
        }
      ] ++ extraModules;
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

      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      _assertHostname = pkgs.lib.asserts.assertMsg (hostname == "") "you must specify a hostname!";

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
          pkgs-unstable
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
      ] ++ extraModules;
    };
}
