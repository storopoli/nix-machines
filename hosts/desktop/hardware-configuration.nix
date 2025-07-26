# This is a generated file.  Do not modify!
# Generate hardware config with: nixos-generate-config --show-hardware-config
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "thunderbolt"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
      verbose = false;
    };

    supportedFilesystems = [
      "ntfs"
      "bcachefs"
      "btrfs"
    ];

    # Fix WiFi speeds
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="US"
    '';
  };

  services = {
    fwupd = {
      enable = true;
      extraRemotes = [ "lvfs-testing" ];
    };

    thermald.enable = true;
  };

  zramSwap.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  security.rtkit.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # AMD
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Enable AMD/Intel microcode
  hardware.enableRedistributableFirmware = true;

  # Fix WiFi speeds
  hardware.wirelessRegulatoryDatabase = true;
}
