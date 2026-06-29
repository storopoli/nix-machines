{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Configure Tailscale hostname
  services.tailscale.extraUpFlags = lib.mkAfter [ "--hostname=ethereum" ];

  services.ethereum = {
    lighthouse-beacon.mainnet = {
      enable = true;
      openFirewall = false;
      package = pkgs.ethereum-nix.lighthouse;
      args = {
        network = "mainnet";
        http.address = "127.0.0.1";
        execution-jwt = "/var/lib/ethereum/jwt.hex";
        execution-endpoint = "http://127.0.0.1:8551";
        checkpoint-sync-url = "https://beaconstate.ethstaker.cc";
      };
    };

    geth.mainnet = {
      enable = true;
      openFirewall = false;
      package = pkgs.ethereum-nix.geth;
      args = {
        authrpc.jwtsecret = "/var/lib/ethereum/jwt.hex";
        http = {
          enable = true;
          addr = "127.0.0.1";
          api = [
            "net"
            "web3"
            "eth"
          ];
        };
      };
    };
  };

  # Expose Ethereum HTTP RPC endpoints on the node's own MagicDNS name
  # (ethereum.dojo-regulus.ts.net) with Tailscale Serve:
  #   * Geth JSON-RPC over HTTPS on :8545
  #   * Lighthouse Beacon HTTP API over HTTPS on :5052
  #
  # The authenticated Engine API stays unserved.
  systemd.services.tailscale-serve =
    let
      tailscale = "${config.services.tailscale.package}/bin/tailscale";
      gethHttpPort = 8545;
      beaconHttpPort = 5052;
    in
    {
      description = "Expose Ethereum RPC endpoints over Tailscale Serve";
      after = [ "tailscaled.service" ];
      wants = [ "tailscaled.service" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${tailscale} serve --yes --bg --https=${toString gethHttpPort} http://127.0.0.1:${toString gethHttpPort}
        ${tailscale} serve --yes --bg --https=${toString beaconHttpPort} http://127.0.0.1:${toString beaconHttpPort}
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "5s";
        ExecStop = [
          "-${tailscale} serve --yes --https=${toString gethHttpPort} off"
          "-${tailscale} serve --yes --https=${toString beaconHttpPort} off"
        ];
      };
    };

  networking.firewall =
    let
      geth = config.services.ethereum.geth.mainnet.args;
      beacon = config.services.ethereum.lighthouse-beacon.mainnet.args;
    in
    {
      # Public Ethereum peer/discovery ports. RPC and engine API ports stay
      # reachable over HTTPS via Tailscale Serve instead of tailnet-facing
      # plaintext listeners.
      allowedTCPPorts = [ geth.port ] ++ lib.optionals beacon.disable-quic [ beacon.quic-port ];
      allowedUDPPorts = [
        geth.port
        beacon.discovery-port
      ]
      ++ lib.optionals (!beacon.disable-quic) [ beacon.quic-port ];
    };
}
