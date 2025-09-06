{
  pkgs,
  username,
  ...
}:

{
  # Tor
  services.tor = {
    enable = true;
    client.enable = true;
  };

  # Fish, fuck bash and zsh
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish ];
  users.users.${username}.shell = pkgs.fish;

  # TPM2 and lanzaboote
  environment.systemPackages = with pkgs; [
    tpm2-tss
    sbctl
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
}
