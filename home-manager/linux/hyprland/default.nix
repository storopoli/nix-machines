{
  pkgs-unstable,
  ...
}:

{
  imports = [
    ./fonts.nix
    ./envs.nix
    ./autostart.nix
    ./input.nix
    ./bindings.nix
    ./looknfeel.nix
    ./windows.nix
  ];

  home.file.".local/bin" = {
    source = ../../../bin;
    recursive = true;
  };

  # Hyprland polkit agent
  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs-unstable.hyprland;
    settings = {
      # Default applications
      "$terminal" = "ghostty";
      "$fileManager" = "nautilus --new-window";
      "$browser" = "brave-browser --new-window --ozone-platform=wayland";
      "$music" = "Cider";
      "$messenger" = "signal-desktop";
      "$webapp" = "$browser --app"; # https://support.brave.app/hc/en-us/articles/360044860011-How-Do-I-Use-Command-Line-Flags-in-Brave

      # Monitor configuration
      monitor = [
        ",preferred,auto,1"
      ];
    };
  };
}
