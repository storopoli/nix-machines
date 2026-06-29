{
  config,
  username,
  lib,
  ...
}:

{
  # Configure Tailscale hostname
  services.tailscale.extraUpFlags = lib.mkAfter [ "--hostname=bitcoin" ];

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

      # Wallet enabled for Sparrow (watch-only wallets via RPC)
      disablewallet = false;

      # Accept incoming peer connections
      listen = true;

      # Enable txindex.
      txindex = true;

      # Listen to connections on all interfaces
      address = "0.0.0.0";

      rpc = {
        # Listen to RPC connections on all interfaces
        address = "0.0.0.0";

        # Allow direct RPC access only from Tailscale peers.
        # see: https://tailscale.com/docs/reference/reserved-ip-addresses
        allowip = [
          "100.64.0.0/10"
          "fd7a:115c:a1e0::/48"
        ];

        # RPC user
        users.public.name = "bitcoin";
      };

      # ZMQ
      zmqpubrawblock = "tcp://0.0.0.0:28332";
      zmqpubrawtx = "tcp://0.0.0.0:28333";

      extraConfig = ''
        mempoolfullrbf=1
        blockfilterindex=1 # BIP158 compact block filters (needed by Wasabi RPC)
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
        address = "127.0.0.1";
        port = 60845;
        settings = {
          LIGHTNING = true;
        };
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
          REST_API_URL = "https://${toString config.services.lnd.restAddress}:${toString config.services.lnd.restPort}";
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
        permissions = ''{"entity":"info","action":"read"},{"entity":"onchain","action":"read"},{"entity":"offchain","action":"read"},{"entity":"address","action":"read"},{"entity":"message","action":"read"},{"entity":"peers","action":"read"},{"entity":"signer","action":"read"},{"entity":"invoices","action":"read"},{"entity":"macaroon","action":"read"}'';
      };
    };
  };

  # Fix Lightning integration for the mempool explorer.
  #
  # nix-bitcoin writes the custom `mempool` macaroon into LND's systemd
  # RuntimeDirectory (`/run/lnd/mempool.macaroon`) via an `ExecStartPost`
  # script that runs as part of `lnd.service`. The nix-bitcoin `mempool`
  # backend service, however, only depends on mysql/electrs and has no
  # ordering relationship with `lnd`. At boot the mempool backend therefore
  # races LND and frequently starts before the macaroon exists, failing with:
  #   ERR: Could not initialize LND Macaroon/TLS Cert. Disabling LIGHTNING.
  #   ENOENT: no such file or directory, open '/run/lnd/mempool.macaroon'
  #
  # Ordering the backend after `lnd.service` (which only becomes active once
  # its ExecStartPost macaroon creation has completed) makes the macaroon
  # guaranteed to exist before mempool reads it.
  systemd.services.mempool = {
    wants = [ "lnd.service" ];
    after = [ "lnd.service" ];
  };

  # Expose services on the node's own MagicDNS name
  # (bitcoin.dojo-regulus.ts.net):
  #   * mempool frontend publicly over HTTPS on :443 with Tailscale Funnel
  #   * electrs tailnet-only over TLS-terminated TCP on :50002 with Tailscale
  #     Serve, forwarding to the plaintext Electrum port on 127.0.0.1
  #
  # Both exposed TLS endpoints require MagicDNS and HTTPS certificates. Funnel
  # additionally requires a `funnel` node attribute in the tailnet policy for
  # this node/user.
  systemd.services.tailscale-serve =
    let
      tailscale = "${config.services.tailscale.package}/bin/tailscale";
    in
    {
      description = "Expose mempool over Tailscale Funnel and electrs over Tailscale Serve";
      after = [
        "tailscaled.service"
        "mempool.service"
        "electrs.service"
      ];
      wants = [
        "tailscaled.service"
        "mempool.service"
        "electrs.service"
      ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${tailscale} funnel --yes --bg --https=443 http://127.0.0.1:${toString config.services.mempool.frontend.port}
        ${tailscale} serve --yes --bg --tls-terminated-tcp=50002 tcp://127.0.0.1:${toString config.services.electrs.port}
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "5s";
        ExecStop = [
          "-${tailscale} funnel --yes --https=443 off"
          "-${tailscale} serve --yes --tls-terminated-tcp=50002 off"
        ];
      };
    };

  # Public firewall openings. Tailscale traffic is accepted by the shared
  # trusted `tailscale0` interface, and Tailscale Serve proxies mempool/electrs
  # from loopback, so private RPC/UI ports don't need public firewall holes.
  networking.firewall.allowedTCPPorts = [
    config.services.bitcoind.port # P2P
  ];
}
