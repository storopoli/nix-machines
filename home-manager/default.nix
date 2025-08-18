{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  username,
  isLinux ? false,
  isDarwin ? false,
  ...
}:

{

  imports = [
    # common home-manager configs
    ./cli
    ./shell
    ./helix.nix
    ./neovim.nix
    ./ghostty.nix
    ./zed.nix
  ]
  ++ lib.optionals isLinux [
    ./linux
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

  # Follow the same stateVersion as the system (NixOS) or set manually (Darwin)
  home.stateVersion = config.system.stateVersion or "25.05";

  # Common user packages
  home.packages =
    with pkgs;
    [
      # System utilities
      curl
      coreutils
      zstd
      pkg-config
      zlib
      just
      sd
      dust
      jq

      # dev
      rustup # NOTE: sp1 and risc0 friendly
      ghc
      cabal-install
      stack
      nodejs
      sqlite
      typst
      cargo-cache
      pkgs-unstable.claude-code

      # Opsec
      age
      age-plugin-yubikey

      # media
      ffmpeg
      presenterm
    ]
    ++ lib.optionals isLinux [
      # System utilities
      exfat

      # Opsec
      keepassxc
      brave
      signal-desktop
      cryptomator
      tor
      torsocks
      tor-browser-bundle-bin
      protonvpn-gui # TODO: move to obscura-vpn once Linux support is available
      transmission_4

      # bitcoin
      sparrow

      # media
      obs-studio
      cider-2

      # programming
      llvm
      python3
      cargo
    ];

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
