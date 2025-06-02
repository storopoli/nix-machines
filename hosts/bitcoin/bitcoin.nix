{ config, username, ... }:

{
  nix-bitcoin = {
    # Automatically generate all secrets required by services.
    # The secrets are stored in /etc/nix-bitcoin-secrets
    generateSecrets = true;

    operator = {
      enable = true;
      name = username;
    };

    # Enable the frontend
    onionServices.mempool-frontend.enable = true;

    # The nix-bitcoin release version that your config is compatible with.
    # When upgrading to a backwards-incompatible release, nix-bitcoin will display an
    # an error and provide instructions for migrating your config to the new release.
    configVersion = "0.0.123";
  };

  services = {
    bitcoind = {
      # Enable BitcoinD
      enable = true;

      # Fuck the wallet
      disablewallet = true;

      # Accept incoming peer connections
      listen = true;

      # Enable txindex.
      txindex = true;

      # Listen to connections on all interfaces
      address = "0.0.0.0";

      # Listen to RPC connections on all interfaces
      rpc.address = "0.0.0.0";

      # Allow RPC connections from external addresses
      rpc.allowip = [
        #"100.64.0.0/10" # Allow a subnet
        #"10.50.0.3" # Allow a specific address
        "0.0.0.0/0" # Allow all addresses
      ];

      extraConfig = ''
        mempoolfullrbf=1
        dbcache=4096 # this will help sync blocks faster
        # Set this to also add IPv6 connectivity.
        bind=::
      '';

      # If you're using the `secure-node.nix` template, set this to allow non-Tor connections
      # to bitcoind
      tor.enforce = false;
      # Also set this if bitcoind should not use Tor for outgoing peer connections
      tor.proxy = false;
    };

    # Indexer
    electrs = {
      enable = true;

      # Listen to connections on all interfaces
      address = "0.0.0.0";

      # Set this if you're using the `secure-node.nix` template
      tor.enforce = false;
    };

    # Enable the mempool space
    mempool = {
      enable = true;
      frontend = {
        enable = true;
        address = "0.0.0.0";
        port = 60845;
      };
      tor = {
        proxy = true;
        enforce = true;
      };
      settings = {
        LIGHTNING = {
          ENABLED = true;
          BACKEND = "lnd";
        };
        LND = {
          TLS_CERT_PATH = "${config.services.lnd.certPath}";
          MACAROON_PATH = "/run/lnd/mempool.macaroon";
          REST_API_URL = "https://${toString config.services.lnd.restAddress}:${
              toString config.services.lnd.restPort
            }";
        };
      };
    };

    # LND node
    lnd = {
      enable = true;
      address = "0.0.0.0";
      rpcAddress = "0.0.0.0";
      restAddress = "0.0.0.0";
      certificate.extraIPs = [ "0.0.0.0" ];
      macaroons.mempool = {
        inherit (config.services.mempool) user;
        permissions = ''
          {"entity":"info","action":"read"},{"entity":"onchain","action":"read"},{"entity":"offchain","action":"read"},{"entity":"address","action":"read"},{"entity":"message","action":"read"},{"entity":"peers","action":"read"},{"entity":"signer","action":"read"},{"entity":"invoices","action":"read"},{"entity":"macaroon","action":"read"}'';
      };
    };
  };

  # Open ports in the firewall
  networking.firewall.allowedTCPPorts = [
    config.services.bitcoind.port # P2P
    config.services.bitcoind.rpc.port # RPC
    config.services.electrs.port # electrs
    config.services.lnd.port # LND
    config.services.lnd.rpcPort # LND
    config.services.lnd.restPort # LND
    config.services.mempool.frontend.port # Mempool
  ];
}
