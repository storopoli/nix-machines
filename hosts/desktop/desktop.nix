{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  # GNOME Desktop Environment
  # TODO: in 25.11 these will change
  #       see <https://wiki.nixos.org/wiki/GNOME>
  services.xserver = {
    enable = lib.mkForce true;
    displayManager.gdm.enable = lib.mkForce true;
    desktopManager.gnome.enable = lib.mkForce true;
    videoDrivers = [ "nvidia" ];
  };

  # Enable sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Tor
  services.tor.client.enable = true;

  # Nvidia Configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Gaming Configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  # Desktop packages
  environment.systemPackages = with pkgs; [
    # System utilities
    tpm2-tss

    # Nvidia
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
  ];

  environment.variables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
  };

  # Enable NetworkManager
  networking.networkmanager.enable = true;

  # zram swap
  zramSwap.enable = true;

  # Home Manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../../home-manager {
      inherit
        config
        lib
        pkgs
        username
        ;
    };
  };
}
