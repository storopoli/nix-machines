{
  inputs,
  ...
}:
{
  inherit
    (import ./helpers.nix {
      inherit inputs;
      inherit (inputs.nixpkgs) lib;
    })
    mkNixos
    ;
}
