{

  pkgs,
  ...
}:

let
  # ghostty is broken on darwin, but ghostty-bin works
  inherit (pkgs.stdenv) isLinux;
  package = if isLinux then pkgs.ghostty else pkgs.ghostty-bin;
in

{
  programs.ghostty = {
    inherit package;
    enable = true;
    enableFishIntegration = true;
    settings = {
      # tmux integration
      command = "${pkgs.fish}/bin/fish -c tmux attach -t base || tmux new -s base";
      shell-integration = "fish";
      theme = "Gruvbox Dark Hard";
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
