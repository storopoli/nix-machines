{
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [ monero-cli ];

  # Configure Tailscale hostname
  services.tailscale.extraUpFlags = lib.mkAfter [ "--hostname=monero" ];

  services.monero = {
    enable = true;

    rpc = {
      address = "0.0.0.0";
      port = 18081;
      restricted = true;
    };

    extraConfig = ''
      confirm-external-bind=true
    '';
  };

  # Keep only the P2P port public. RPC binds on all interfaces for Tailscale
  # access, but it does not need a public firewall opening.
  networking.firewall.allowedTCPPorts = [ 18080 ];
}
