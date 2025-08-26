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

    package = pkgs.brave;

    commandLineArgs = [ "--ozone-platform=wayland" ];

    dictionaries = with pkgs; [
      hunspellDictsChromium.en_US
    ];

    extensions = [
      { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # Proton Pass
    ];
  };
}
