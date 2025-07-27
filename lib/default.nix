{ inputs, ... }:
{
  inherit (import ./helpers.nix { inherit inputs; }) mkNixos mkDarwin;
}
