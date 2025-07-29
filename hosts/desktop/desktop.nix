{
  lib,
  pkgs,
  pkgs-unstable,
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

  # Tor
  services.tor.client.enable = true;

  # Fish, fuck bash and zsh
  environment.shells = with pkgs; [ fish ];

  # TPM2
  environment.systemPackages = with pkgs; [
    tpm2-tss
  ];

  networking = {
    # Firewall
    firewall.enable = true;

    # Enable NetworkManager
    networkmanager.enable = true;

    # WireGuard
    wireguard.enable = true;
  };

  # zram swap
  zramSwap.enable = true;

  # Home Manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../../home-manager;
    extraSpecialArgs = {
      inherit username pkgs-unstable;
    };
  };
}
