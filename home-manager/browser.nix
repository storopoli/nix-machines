{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  isLinux = pkgs.stdenv.isLinux;
in

{
  programs.chromium = lib.mkIf isLinux {
    enable = true;
    package = pkgs-unstable.brave;

    commandLineArgs = [ "--ozone-platform=wayland" ];

    dictionaries = with pkgs-unstable; [
      hunspellDictsChromium.en_US
    ];

    extensions = [
      { id = "pejdijmoenmkgeppbflobdenhhabjlaj"; } # iCloud Passwords
    ];
  };
}
