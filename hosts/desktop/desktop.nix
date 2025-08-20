{
  pkgs,
  inputs,
  username,
  ...
}:

let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  nix-colors = inputs.nix-colors;
in

{
  # Tor
  services.tor.client.enable = true;

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

  # Home Manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = {
      imports = [
        ../../home-manager
        ../../home-manager/gaming.nix
      ];
    };
    extraSpecialArgs = {
      inherit
        inputs
        username
        isLinux
        isDarwin
        pkgs
        nix-colors
        ;
      gnome = false;
      hyprland = true;
    };
  };
}
