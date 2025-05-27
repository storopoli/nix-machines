{ inputs, pkgs, ... }:
let inherit (inputs) nixpkgs nixpkgs-unstable;
in {
  environment.systemPackages = with pkgs; [
    ## stable
    git
    curl
    just
    vim
    doas
  ];
}
