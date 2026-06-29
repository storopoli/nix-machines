{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Zebra configuration file
  zebraConfig = pkgs.writeText "zebrad.toml" ''
    [network]
    network = "Mainnet"
    listen_addr = "0.0.0.0:8233"

    [state]
    cache_dir = "/var/lib/zebra"

    [rpc]
    listen_addr = "127.0.0.1:8232"
    enable_cookie_auth = false

    [tracing]
    progress_bar = "never"
  '';
in
{
  # Configure Tailscale hostname
  services.tailscale.extraUpFlags = lib.mkAfter [ "--hostname=zcash" ];

  # Create dedicated user and group for zebra
  users.users.zcash = {
    isSystemUser = true;
    group = "zcash";
    home = "/var/lib/zebra";
    description = "Zcash Zebra node user";
  };

  users.groups.zcash = { };

  systemd =
    let
      tailscale = "${config.services.tailscale.package}/bin/tailscale";
    in
    {
      # Ensure state directory exists with correct permissions
      tmpfiles.rules = [
        "d /var/lib/zebra 0750 zcash zcash -"
      ];

      services = {
        # Zebra systemd service
        zebrad = {
          description = "Zcash Full Node (Zebra)";
          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];

          serviceConfig = {
            Type = "simple";
            User = "zcash";
            Group = "zcash";
            ExecStart = "${pkgs.zebrad}/bin/zebrad start --config ${zebraConfig}";
            Restart = "on-failure";
            RestartSec = "30s";

            # Hardening
            PrivateTmp = true;
            NoNewPrivileges = true;
            ProtectSystem = "strict";
            ProtectHome = true;
            ReadWritePaths = [ "/var/lib/zebra" ];

            # Resource limits
            LimitNOFILE = 65535;
          };
        };

        # Expose the Zebra JSON-RPC endpoint on the node's own MagicDNS name
        # (zcash.dojo-regulus.ts.net) over TLS-terminated TCP on :8232 with
        # Tailscale Serve.
        tailscale-serve = {
          description = "Expose Zcash RPC over Tailscale Serve";
          after = [ "tailscaled.service" ];
          wants = [ "tailscaled.service" ];
          wantedBy = [ "multi-user.target" ];
          script = ''
            ${tailscale} serve --yes --bg --tls-terminated-tcp=8232 tcp://127.0.0.1:8232
          '';
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            Restart = "on-failure";
            RestartSec = "5s";
            ExecStop = [ "-${tailscale} serve --yes --tls-terminated-tcp=8232 off" ];
          };
        };
      };
    };

  # Open firewall ports
  # 8233 = P2P (Mainnet)
  # 8232 = RPC
  # Keep only the P2P port public. Tailscale Serve proxies RPC from loopback,
  # so it does not need a public firewall opening or a tailnet-facing plaintext
  # listener.
  networking.firewall.allowedTCPPorts = [
    8233
  ];
}
