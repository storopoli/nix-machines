{
  lib,
  pkgs,
  username,
  ...
}:

{
  # Tor
  services.tor.client.enable = true;

  # Fish, fuck bash and zsh
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish ];
  users.users.${username}.shell = pkgs.fish;

  environment.systemPackages = with pkgs; [
    # TPM2
    tpm2-tss

    # lanzaboote
    sbctl

    # framework
    framework-tool
  ];

  networking = {
    # Firewall
    firewall.enable = true;

    # Enable NetworkManager
    networkmanager.enable = true;

    # WireGuard
    wireguard.enable = true;
  };

  # Fix WiFi speeds
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="US"
  '';

  # zram swap
  zramSwap.enable = true;

  # Fucking binaries
  programs.nix-ld.enable = true;

  # Timezone
  time.timeZone = lib.mkForce "America/Sao_Paulo";
}
