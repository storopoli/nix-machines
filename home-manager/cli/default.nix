{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./lazygit.nix
    ./ripgrep.nix
    ./yazi.nix
    ./yt-dlp.nix
    ./zoxide.nix
  ];
}
