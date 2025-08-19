# Some common expressions between systems, one can call this expression as it was "configuration.nix".
{
  pkgs,
  stateVersion,
  username,
  ...
}:

{
  system.stateVersion = stateVersion;

  environment.systemPackages = with pkgs; [
    # Terminal
    doas
    tree
    curl
    ripgrep
    fd
    sd
    rsync
    jq
    just
    git
    helix

    # ssh
    openssh
    ssh-copy-id

    # age
    age
    age-plugin-yubikey

    # archive
    xz
    zstd
    lz4
    p7zip
  ];

  # root password
  users.users.root.hashedPassword = "$y$j9T$bQQD1tHdgxA4qTFI1s4ih/$zOgREkZW2woes8c741V4mPpY0EP.7LlUu3MVVFGTnJ.";

  # Userland
  users.users.${username} = {
    isNormalUser = true;
    description = "user";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "gamemode"
      "libvirtd"
      "video"
      "audio"
    ];
    hashedPassword = "$y$j9T$cQZQPmIVl64rervwIFIAT1$ZVLx2KkTMnWpCGKnxqHv.ptnz7pGl2WzBxkUyeQsXFB";
    packages = with pkgs; [
      hello
    ];
  };

  services = {
    # Limit systemd log retention for privacy reasons
    journald.extraConfig = ''
      MaxRetentionSec=36h
    '';
    qemuGuest.enable = true;
    xserver = {
      enable = false;
    };
  };
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      # 500mb buffer
      download-buffer-size = 500000000;
      auto-optimise-store = true;
    };

    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5";
    };
  };

  # Traffic congestion control
  boot = {
    kernelModules = [ "tcp_bbr" ];
    kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };

  # System localization
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # Hardware configuration
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
