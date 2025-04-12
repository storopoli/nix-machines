{ config, inputs, pkgs, name, lib, ... }:

{
  imports = [
    inputs.self.lib.tailscale
  ];

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

  # Limit systemd log retention for privacy reasons
  services.journald.extraConfig = ''
    MaxRetentionSec=36h
  '';
}