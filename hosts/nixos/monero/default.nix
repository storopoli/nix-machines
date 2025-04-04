{ config, inputs, pkgs, name, lib, ... }:

{
  imports =
    [
      sops-nix.nixosModules.sops
      ./hardware-configuration.nix
      ./../../common/nixos-common.nix
      ./../../common/common-packages.nix
      ./monero.nix
    ];

  # Boot configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Network configuration
  networking = {
    firewall.enable = true;
    hostName = "monero";
    interfaces.ens18.useDHCP = true;
  };

  # System localization
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = false;
    #videoDrivers = [ "nvidia" ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "yes";

  };
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLqHZrt6LpY13sVkGWbiofJgF+IayppaMwHuEt51chWVFfE7hBt7tN5356+a7ZqU6NaTRN4IIlEvPUm+SUxOp10= ssh@secretive.macbook.local"
    ];
  };
  services.qemuGuest.enable = true;

  # userland
  #home-manager.useGlobalPkgs = true;
  #home-manager.useUserPackages = true;
  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    hashedPassword = "$y$j9T$Kc2C6sXOMPZ6T76SDsqmO.$zcxamWONhz7kyNRSdX6syCQuXlky/gRo2mjOlo2UceA";
    packages = with pkgs; [
      #home-manager
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