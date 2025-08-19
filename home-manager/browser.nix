{
  lib,
  pkgs,
  ...
}:

let
  isLinux = pkgs.stdenv.isLinux;
in

{
  programs.chromium = lib.mkIf isLinux {
    enable = true;
    commandLineArgs = [ "--ozone-platform=wayland" ];

    dictionaries = with pkgs; [
      hunspellDictsChromium.en_US
    ];

    extensions = [
      { id = "pejdijmoenmkgeppbflobdenhhabjlaj"; } # iCloud Passwords
    ];
  };
}
