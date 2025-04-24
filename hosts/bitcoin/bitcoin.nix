{
  config,
  username,
  ...
}:

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
    configVersion = "0.0.85";
  };

  services = {
    bitcoind = {
      # Enable BitcoinD
      enable = true;

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
    };
  };

  # Open ports in the firewall
  networking.firewall.allowedTCPPorts = [
    config.services.bitcoind.port # P2P
    config.services.bitcoind.rpc.port # RPC
    config.services.electrs.port # electrs
  ];
}
