{
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
    listen_addr = "0.0.0.0:8232"
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

  # Ensure state directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/zebra 0750 zcash zcash -"
  ];

  # Zebra systemd service
  systemd.services.zebrad = {
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

  # Open firewall ports
  # 8233 = P2P (Mainnet)
  # 8232 = RPC
  networking.firewall.allowedTCPPorts = [
    8233
    8232
  ];
}
