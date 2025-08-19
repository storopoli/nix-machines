{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  username,
  isLinux ? false,
  isDarwin ? false,
  gnome ? false,
  hyprland ? false,
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
    ./browser.nix
  ]
  ++ lib.optionals isLinux [
    ./linux
  ]
  ++ lib.optionals gnome [
    ./gnome.nix
  ]
  ++ lib.optionals hyprland [
    ./linux/hyprland
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
      pkgs-unstable.presenterm
    ]
    ++ lib.optionals isLinux [
      # System utilities
      exfat

      # Opsec
      pkgs-unstable.keepassxc
      pkgs-unstable.signal-desktop
      pkgs-unstable.cryptomator
      tor
      torsocks
      pkgs-unstable.tor-browser-bundle-bin
      pkgs-unstable.protonvpn-gui # TODO: move to obscura-vpn once Linux support is available
      transmission_4

      # bitcoin
      pkgs-unstable.sparrow

      # media
      obs-studio
      pkgs-unstable.cider-2

      # programming
      llvm
      python3
      cargo
    ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
