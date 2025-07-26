# Some common expressions between systems, one can call this expression as it was "configuration.nix".
{
  pkgs,
  module, # Should be any of the derivations, [ "bitcoin", "monero", "matrix"].
  stateVersion,
  username,
  inputs,
  ...
}:
let
  _assertModule = pkgs.lib.asserts.assertMsg (module == "") "you must specify a hostname!";
in
{
  system.stateVersion = stateVersion;

  imports = [ (import ./${module} { inherit module inputs; }) ];

  # stable
  environment.systemPackages = with pkgs; [
    git
    curl
    just
    helix
    doas
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
    };
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5";
    };
  };
  # Boot configuration
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
