{
  pkgs,
  unstablePkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  time.timeZone = "UTC";
  system.stateVersion = "25.05";

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      # 500mb buffer
      download-buffer-size = 500000000;
      auto-optimise-store = true;
    };
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5";
    };
  };
}
