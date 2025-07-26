{ inputs, pkgs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  # stable
  environment.systemPackages = with pkgs; [
    git
    curl
    just
    helix
    doas
  ];

}
