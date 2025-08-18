{
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "hyprsunset"
      "systemctl --user start hyprpolkitagent"
      "wl-clip-persist --clipboard regular & clipse -listen"
    ];

    exec = [
      "pkill -SIGUSR2 waybar || waybar"
    ];
  };
}
