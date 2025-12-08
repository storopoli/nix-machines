# lib/helper.nix
{
  inputs,
  lib,
  ...
}:

{
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
      # Feature options
      virtualisation ? true,
      dns ? true,
      doas ? true,
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
          hostname
          ;
        module = hostname;
      };

      systemExpression = import ../hosts/${hostname} {
        inherit inputs username;
        module = hostname;
      };

      # Conditional modules based on options
      conditionalModules =
        lib.optionals virtualisation [ (import ./virtualisation.nix) ]
        ++ lib.optionals dns [ (import ./dns.nix) ]
        ++ lib.optionals doas [ (import ./doas.nix) ];

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
          nixpkgs = {
            config.allowUnfree = true;
            overlays = [ ];
          };
        }
        commonExpression
        systemExpression
        inputs.disko.nixosModules.disko
        (import ./tailscale.nix)
        (import ./ssh.nix)
      ]
      ++ conditionalModules
      ++ extraModules;
    };
}
