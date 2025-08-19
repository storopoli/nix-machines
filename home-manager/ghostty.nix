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
  # TODO: ghostty is broken on darwin
  programs.ghostty = lib.mkIf isLinux {
    enable = true;
    package = pkgs-unstable.ghostty;
    enableFishIntegration = true;
    settings = {
      shell-integration = "fish";
      theme = "GruvboxDarkHard";
      font-feature = [
        "-calt"
        "-liga"
        "-dlig"
      ];
      window-width = 3000;
      window-height = 2100;
      background-opacity = 0.9;
      background-blur-radius = 20;
      quit-after-last-window-closed = true;
      macos-option-as-alt = "left";
      keybind = [
        "super+grave_accent=toggle_quick_terminal"
        "alt+left=unbind"
        "alt+right=unbind"

        # Vim Keybinds
        "super+alt+h=goto_split:left"
        "super+alt+l=goto_split:right"
        "super+alt+j=goto_split:bottom"
        "super+alt+k=goto_split:top"

        "super+ctrl+h=resize_split:left,10"
        "super+ctrl+l=resize_split:right,10"
        "super+ctrl+j=resize_split:down,10"
        "super+ctrl+k=resize_split:up,10"

        # Claude
        "shift+enter=text:\\n"
      ];
    };
  };
}
