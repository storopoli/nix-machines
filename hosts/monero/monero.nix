{
  config,
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
      address = "127.0.0.1";
      restricted = true;
    };
  };

  # Expose the restricted Monero daemon RPC endpoint on the node's own MagicDNS
  # name (monero.dojo-regulus.ts.net) over TLS-terminated TCP on :18081 with
  # Tailscale Serve.
  systemd.services.tailscale-serve =
    let
      tailscale = "${config.services.tailscale.package}/bin/tailscale";
      moneroRpcPort = 18081;
    in
    {
      description = "Expose Monero RPC over Tailscale Serve";
      after = [ "tailscaled.service" ];
      wants = [ "tailscaled.service" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${tailscale} serve --yes --bg --tls-terminated-tcp=${toString moneroRpcPort} tcp://127.0.0.1:${toString moneroRpcPort}
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "5s";
        ExecStop = [ "-${tailscale} serve --yes --tls-terminated-tcp=${toString moneroRpcPort} off" ];
      };
    };

  # Keep only the P2P port public. Tailscale Serve proxies RPC from loopback,
  # so it does not need a public firewall opening or a tailnet-facing plaintext
  # listener.
  networking.firewall.allowedTCPPorts = [ 18080 ];
}
