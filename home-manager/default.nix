{
  config,
  lib,
  pkgs,
  username,
  isLinux ? false,
  isDarwin ? false,
  gnome ? false,
  hyprland ? false,
  nvidia ? false,
  gaming ? false,
  ...
}:

{

  imports = [
    # common home-manager configs
    ./cli
    ./shell
    ./helix
    # ./neovim.nix # NOTE: using helix as default editor
    ./ghostty.nix
    # ./zed.nix
    ./browser.nix
  ]
  ++ lib.optionals isLinux [
    # ./linux/mold.nix # NOTE: rust uses `lld` by default in 1.90+
  ]
  ++ lib.optionals gnome [
    ./linux/gnome.nix
  ]
  ++ lib.optionals hyprland [
    (import ./linux/hyprland { inherit lib nvidia; })
  ]
  ++ lib.optionals gaming [
    ./gaming.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

  # Follow the same stateVersion as the system (NixOS) or set manually (Darwin)
  home.stateVersion = config.system.stateVersion or "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
      openssl
      just
      sd
      dust
      jq

      # dev
      #cargo # TODO: remove rustup + cargo below
      ghc
      cabal-install
      stack
      python3
      uv
      nodejs
      sqlite
      typst
      lazydocker
      cargo-cache
      cargo-nextest
      cargo-hack
      nix-init

      # Opsec
      age
      age-plugin-yubikey

      # media
      ffmpeg
      presenterm
    ]
    ++ lib.optionals isDarwin [
      # dev
      rustup # NOTE: sp1 and risc0 friendly
    ]
    ++ lib.optionals isLinux [
      # System utilities
      unzip
      exfat

      # Opsec
      keepassxc
      signal-desktop
      cryptomator
      tor
      torsocks
      tor-browser-bundle-bin
      protonvpn-gui # TODO: move to obscura-vpn once Linux support is available
      transmission_4-gtk

      # bitcoin
      sparrow

      # media
      obs-studio
      cider-2

      # programming
      cargo
      gcc
    ];
}
