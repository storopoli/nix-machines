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
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit username;
      };
      modules = [
        ../hosts/${hostname}
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ../hosts/home-manager;
          home-manager.extraSpecialArgs = {
            inherit username;
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

      _assertHostname = pkgs.lib.asserts.assertMsg (hostname == "") "you must specify a hostname!";

      unstablePkgs = import inputs.nixpkgs-unstable {
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
      tailscaleModule = import ./tailscale.nix;
      sshModule = import ./ssh.nix;

    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          unstablePkgs
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
        tailscaleModule
        sshModule
      ]
      ++ extraModules;
    };
}
