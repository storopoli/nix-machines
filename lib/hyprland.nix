{
  pkgs,
  username,
  ...
}:

let
  # Essential Hyprland packages - cannot be excluded
  hyprlandPackages = with pkgs; [
    hyprshot
    hyprpicker
    hyprsunset
    brightnessctl
    pamixer
    playerctl
    gnome-themes-extra
    pavucontrol
  ];
in
{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  # System packages for Hyprland ecosystem
  environment.systemPackages =
    with pkgs;
    [
      libnotify
      nautilus
      blueberry
      clipse
      vlc

      # GTK themes and icons
      adwaita-icon-theme
      gnome-themes-extra
    ]
    ++ hyprlandPackages;

  # Display manager for Wayland
  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = username;
        };
      };
    };
  };

  # Polkit
  security.polkit.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    font-awesome
    nerd-fonts.caskaydia-mono
  ];

  # Environment variables for Wayland
  environment.sessionVariables = {
    # Nvidia-specific variables for Wayland
    WLR_NO_HARDWARE_CURSORS = "1"; # Nvidia compatibility
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";

    # General Wayland variables
    NIXOS_OZONE_WL = "1"; # Enable Wayland for Chromium/Electron apps
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland,x11";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
  };
}
