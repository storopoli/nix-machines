{
  lib,
  isLinux ? false,
  ...
}:

{
  dconf = lib.mkIf isLinux {
    enable = true;
    settings = {
      # GNOME Dark mode
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      # Better video display
      "org/gnome/mutter" = {
        experimental-features = [
          "scale-monitor-framebuffer" # Enables fractional scaling (125% 150% 175%)
          "variable-refresh-rate" # Enables Variable Refresh Rate (VRR) on compatible displays
          "xwayland-native-scaling" # Scales Xwayland applications to look crisp on HiDPI screens
        ];
      };
    };
  };
}
