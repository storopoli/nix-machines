# lib/helper.nix
{ inputs, ... }:
{
  mkNixos =
    {
      hostname,
      username ? "user",
      system ? "x86_64-linux",
      stateVersion ? "25.05",
      extraModules ? [ ],
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

      systemExpression = import ../hosts {
        inherit pkgs stateVersion inputs;
        module = hostname;
        inherit username;
      };
      tailscaleModule = import ./tailscale.nix;

    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          pkgs
          unstablePkgs
          inputs
          system
          hostname
          username
          ;
      };
      modules = [
        systemExpression
        tailscaleModule
      ] ++ extraModules;
    };
}
