{
  config,
  pkgs,
  username,
  ...
}:

{

  imports = [
    # common home-manager configs
    ./cli
    ./shell
    ./linux
    ./helix.nix
    # ./ghostty.nix # TODO: fix in 25.11
    ./gaming.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Follow the same stateVersion as the system
  home.stateVersion = config.system.stateVersion;

  # Common user packages
  home.packages = with pkgs; [
    # System utilities
    curl
    coreutils
    exfat
    zstd

    # dev
    typst
    just
    presenterm
    claude-code

    # Opsec
    brave
    keepassxc
    cryptomator
    age
    age-plugin-yubikey
    protonvpn-gui
    tor-browser-bundle-bin
    signal-desktop
    transmission_4

    # bitcoin
    sparrow

    # media
    ffmpeg
    obs-studio

    # Secure Boot
    sbctl
  ];

  dconf = {
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
