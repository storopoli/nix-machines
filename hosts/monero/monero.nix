{
  pkgs,
  config,
  username,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    monero-cli
  ];

  # Configure Tailscale hostname
  services.tailscale.extraUpFlags = lib.mkAfter [
    "--hostname=monero"
  ];

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

  # Open the RPC port in the firewall
  networking.firewall.allowedTCPPorts = [ 18081 ];
}
