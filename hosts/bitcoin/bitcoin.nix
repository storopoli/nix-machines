{
  config,
  username,
  lib,
  ...
}:

let
  nbLib = config.nix-bitcoin.lib;
  mkLocalOnionService =
    address: port:
    nbLib.mkOnionService {
      inherit port;
      target = {
        addr = nbLib.address address;
        inherit port;
      };
    };
in
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

    # Onion services for public/private Bitcoin node access:
    #   * mempool-frontend: mempool web UI over Tor
    #   * bitcoind: Bitcoin Core P2P over Tor
    #   * electrs: Electrum protocol over Tor
    #   * lnd: LND P2P over Tor, announced as LND's external address
    #   * sshd: SSH over Tor, provided by the secure-node preset
    onionServices = {
      mempool-frontend.enable = true;
      bitcoind = {
        enable = true;
        public = true;
      };
      electrs.enable = true;
      lnd = {
        enable = true;
        public = true;
      };
    };

    onionAddresses.access.${username} = lib.mkAfter [
      "bitcoind-rpc"
      "lnd-rpc"
      "lnd-rest"
      "sshd"
    ];

    # The nix-bitcoin release version that your config is compatible with.
    # When upgrading to a backwards-incompatible release, nix-bitcoin will display an
    # an error and provide instructions for migrating your config to the new release.
    configVersion = "0.0.123";
  };

  services = {
    tor.relay.onionServices = {
      "bitcoind-rpc" =
        mkLocalOnionService config.services.bitcoind.rpc.address config.services.bitcoind.rpc.port;
      "lnd-rpc" = mkLocalOnionService config.services.lnd.rpcAddress config.services.lnd.rpcPort;
      "lnd-rest" = mkLocalOnionService config.services.lnd.restAddress config.services.lnd.restPort;
    };

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
        # Listen to local RPC connections only; Tailscale Serve exposes this
        # over HTTPS on the node's MagicDNS name.
        address = "127.0.0.1";

        # Allow RPC access from local services and the Tailscale Serve proxy.
        allowip = [
          "127.0.0.1"
          "::1"
        ];

        # RPC user
        users.public.name = "bitcoin";
      };

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

      # Listen to local connections only; Tailscale Serve exposes Electrs over
      # TLS on the node's MagicDNS name.
      address = "127.0.0.1";

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

      # Listen to local connections only; remote access goes through the
      # lnd-rpc/lnd-rest onion services, which target these addresses.
      rpcAddress = "127.0.0.1";
      restAddress = "127.0.0.1";
      macaroons.mempool = {
        inherit (config.services.mempool) user;
        permissions = ''{"entity":"info","action":"read"},{"entity":"onchain","action":"read"},{"entity":"offchain","action":"read"},{"entity":"address","action":"read"},{"entity":"message","action":"read"},{"entity":"peers","action":"read"},{"entity":"signer","action":"read"},{"entity":"invoices","action":"read"},{"entity":"macaroon","action":"read"}'';
      };
    };

    # Keep longer logs than the shared 36h baseline: this host runs
    # financial infrastructure and needs history for incident response.
    journald.extraConfig = lib.mkForce ''
      MaxRetentionSec=3month
    '';
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
  systemd.services = {
    mempool = {
      wants = [ "lnd.service" ];
      after = [ "lnd.service" ];
    };

    # Expose services on the node's own MagicDNS name
    # (bitcoin.dojo-regulus.ts.net):
    #   * mempool frontend publicly over HTTPS on :443 with Tailscale Funnel
    #
    # Funnel requires a `funnel` node attribute in the tailnet policy for this
    # node/user.
    tailscale-funnel =
      let
        tailscale = "${config.services.tailscale.package}/bin/tailscale";
      in
      {
        description = "Expose mempool over Tailscale Funnel";
        after = [
          "tailscaled.service"
          "mempool.service"
        ];
        wants = [
          "tailscaled.service"
          "mempool.service"
        ];
        wantedBy = [ "multi-user.target" ];
        script = ''
          ${tailscale} funnel --yes --bg --https=443 http://127.0.0.1:${toString config.services.mempool.frontend.port}
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = "5s";
          ExecStop = [ "-${tailscale} funnel --yes --https=443 off" ];
        };
      };

    # Expose private services on the node's own MagicDNS name
    # (bitcoin.dojo-regulus.ts.net):
    #   * Bitcoin Core JSON-RPC tailnet-only over TLS-terminated TCP on :8332 with
    #     Tailscale Serve, forwarding to the plaintext RPC port on 127.0.0.1
    #   * electrs tailnet-only over TLS-terminated TCP on :50002 with Tailscale
    #     Serve, forwarding to the plaintext Electrum port on 127.0.0.1
    #
    # These exposed TLS endpoints require MagicDNS and HTTPS certificates.
    tailscale-serve =
      let
        tailscale = "${config.services.tailscale.package}/bin/tailscale";
        bitcoindRpcPort = 8332;
      in
      {
        description = "Expose Bitcoin RPC and electrs over Tailscale Serve";
        after = [
          "tailscaled.service"
          "bitcoind.service"
          "electrs.service"
        ];
        wants = [
          "tailscaled.service"
          "bitcoind.service"
          "electrs.service"
        ];
        wantedBy = [ "multi-user.target" ];
        script = ''
          ${tailscale} serve --yes --bg --tls-terminated-tcp=${toString bitcoindRpcPort} tcp://127.0.0.1:${toString bitcoindRpcPort}
          ${tailscale} serve --yes --bg --tls-terminated-tcp=50002 tcp://127.0.0.1:${toString config.services.electrs.port}
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = "5s";
          ExecStop = [
            "-${tailscale} serve --yes --tls-terminated-tcp=${toString bitcoindRpcPort} off"
            "-${tailscale} serve --yes --tls-terminated-tcp=50002 off"
          ];
        };
      };
  };

  # Public firewall openings. Tailscale traffic is accepted by the shared
  # trusted `tailscale0` interface, and Tailscale Serve proxies mempool/electrs
  # from loopback, so private RPC/UI ports don't need public firewall holes.
  networking.firewall.allowedTCPPorts = [
    config.services.bitcoind.port # P2P
  ];
}
