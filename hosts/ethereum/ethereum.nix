{
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
      openFirewall = true;
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
      openFirewall = true;
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
}
