{
  inputs,
  ...
}:
{
  inherit
    (import ./helpers.nix {
      inherit inputs;
      lib = inputs.nixpkgs.lib;
    })
    mkNixos
    mkDarwin
    ;
}
