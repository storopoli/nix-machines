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

  environment.systemPackages = with pkgs; [
    ## stable
    git
    curl
    just
    helix
    doas
  ];
  # userland
  users.users.${username} = {
    isNormalUser = true;
    description = "user";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    hashedPassword = "$y$j9T$iTXoDEZ5x7aQVXMN7KWT70$CGPkAv13F1Zk8S9PEUrKIMvR34O00A9Lp3KYCuVwaVB";
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
