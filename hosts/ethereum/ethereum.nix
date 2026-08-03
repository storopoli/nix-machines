{
  config,
  lib,
  pkgs,
  ...
}:

let
  jwtSecret = "/var/lib/ethereum/jwt.hex";

  gethPort = 30303;
  gethHttpPort = 8545;
  gethAuthrpcPort = 8551;

  beaconHttpPort = 5052;
  beaconMetricsPort = 5054;
  beaconDiscoveryPort = 9000;
  beaconQuicPort = beaconDiscoveryPort + 1;
  beaconDisableQuic = false;
in
{
  # Configure Tailscale hostname
  services.tailscale.extraUpFlags = lib.mkAfter [ "--hostname=ethereum" ];

  # `settings` is a freeform attrset that ethereum.nix renders into CLI flags:
  # dashed keys for lighthouse, dotted keys for geth. It carries no defaults of
  # its own, so every flag this host relies on is spelled out below.
  services.ethereum = {
    lighthouse-beacon.mainnet = {
      enable = true;
      openFirewall = false;
      package = pkgs.ethereum-nix.lighthouse;
      # ethereum.nix renders `settings.network` into `--network` twice, which
      # clap rejects as a repeated argument, so the network is picked here.
      extraArgs = [
        "--network"
        "mainnet"
      ];
      settings = {
        http = true;
        http-address = "127.0.0.1";
        http-port = beaconHttpPort;
        metrics = true;
        metrics-address = "127.0.0.1";
        metrics-port = beaconMetricsPort;
        discovery-port = beaconDiscoveryPort;
        quic-port = beaconQuicPort;
        disable-quic = beaconDisableQuic;
        disable-upnp = true;
        execution-jwt = jwtSecret;
        execution-endpoint = "http://127.0.0.1:${toString gethAuthrpcPort}";
        checkpoint-sync-url = "https://beaconstate.ethstaker.cc";
      };
    };

    geth.mainnet = {
      enable = true;
      openFirewall = false;
      package = pkgs.ethereum-nix.geth;
      settings = {
        port = gethPort;
        http = true;
        "http.addr" = "127.0.0.1";
        "http.port" = gethHttpPort;
        "http.api" = [
          "net"
          "web3"
          "eth"
        ];
        "authrpc.addr" = "127.0.0.1";
        "authrpc.port" = gethAuthrpcPort;
        "authrpc.jwtsecret" = jwtSecret;
      };
    };
  };

  # Expose Ethereum HTTP RPC endpoints on the node's own MagicDNS name
  # (ethereum.dojo-regulus.ts.net) with Tailscale Serve:
  #   * Geth JSON-RPC over TLS-terminated TCP on :8545
  #   * Lighthouse Beacon HTTP API over TLS-terminated TCP on :5052
  #
  # The authenticated Engine API stays unserved.
  systemd.services.tailscale-serve =
    let
      tailscale = "${config.services.tailscale.package}/bin/tailscale";
    in
    {
      description = "Expose Ethereum RPC endpoints over Tailscale Serve";
      after = [ "tailscaled.service" ];
      wants = [ "tailscaled.service" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${tailscale} serve --yes --bg --tls-terminated-tcp=${toString gethHttpPort} tcp://127.0.0.1:${toString gethHttpPort}
        ${tailscale} serve --yes --bg --tls-terminated-tcp=${toString beaconHttpPort} tcp://127.0.0.1:${toString beaconHttpPort}
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "5s";
        ExecStop = [
          "-${tailscale} serve --yes --tls-terminated-tcp=${toString gethHttpPort} off"
          "-${tailscale} serve --yes --tls-terminated-tcp=${toString beaconHttpPort} off"
        ];
      };
    };

  networking.firewall = {
    # Public Ethereum peer/discovery ports. RPC and engine API ports stay
    # reachable over HTTPS via Tailscale Serve instead of tailnet-facing
    # plaintext listeners.
    allowedTCPPorts = [ gethPort ] ++ lib.optionals beaconDisableQuic [ beaconQuicPort ];
    allowedUDPPorts = [
      gethPort
      beaconDiscoveryPort
    ]
    ++ lib.optionals (!beaconDisableQuic) [ beaconQuicPort ];
  };
}
