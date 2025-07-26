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
  #home-manager.useGlobalPkgs = true;
  #home-manager.useUserPackages = true;
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
      #home-manager
      hello
    ];
  };

  services = {
    # Limit systemd log retention for privacy reasons
    journald.extraConfig = ''
      MaxRetentionSec=36h
    '';
    qemuGuest.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "yes";
      };
    };
    xserver = {
      enable = false;
      #videoDrivers = [ "nvidia" ];
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
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKU4O0J7gdU1+0/IoVZUtajfmWGGNmA3TFXTsbnQfpwt"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJxv4Hr9OPL1ZMx+jVm2vp4kjJIJVGVIkpnfBO3+Zr8"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG83q6Dr8kaTFt9nIFN6gaXujSeMGWtRyejTcqFvGDAF"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrqm5G5d/AVqhGhaE20iRzLc1u6fySR9ul2e9RbQVio"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDv682q7hmMYG2iBpgg9fI5TOJbAx/9P1K2KjsL7q16HAAAABHNzaDo="
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEMt3wUpLy0Kx7876EO7CUMGj7BKNeF9wLZPOSR2p4JtAAAABHNzaDo="
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGIhKrCL5QLSi8cRUVvf1uAQiEJwc7Ew8TFgjdtvnSqX"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJKBilUg02Tv3rOOxlOVBl1eUMpEpCgTSahQhBY/XTU"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3YtfEbv02sDCJmRIOH8hlhEF93/Ory6IE2OKCkhAk+"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEN7VdD0bF+/Y6dYT+7xoqbWAgTXYaR1pTRcjenw2Px4"
    ];
  };
  # Hardware configuration
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
