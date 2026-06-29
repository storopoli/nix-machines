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
        http.address = "0.0.0.0";
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
          addr = "0.0.0.0";
          api = [
            "net"
            "web3"
            "eth"
          ];
        };
      };
    };
  };

  networking.firewall =
    let
      geth = config.services.ethereum.geth.mainnet.args;
      beacon = config.services.ethereum.lighthouse-beacon.mainnet.args;
    in
    {
      # Public Ethereum peer/discovery ports. RPC and engine API ports stay
      # reachable over Tailscale via the shared trusted `tailscale0` interface.
      allowedTCPPorts = [ geth.port ] ++ lib.optionals beacon.disable-quic [ beacon.quic-port ];
      allowedUDPPorts = [
        geth.port
        beacon.discovery-port
      ]
      ++ lib.optionals (!beacon.disable-quic) [ beacon.quic-port ];
    };
}
