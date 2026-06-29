{
  config,
  lib,
  ...
}:

{
  # Configure Tailscale hostname
  services.tailscale.extraUpFlags = lib.mkAfter [ "--hostname=matrix" ];

  # HTTP, HTTPS, and Matrix federation. Bridge ports remain reachable over
  # Tailscale via the shared trusted `tailscale0` interface.
  networking.firewall.allowedTCPPorts = [
    80
    443
    8448
  ];

  services.matrix-tuwunel = {
    enable = true;
    settings = {
      global = {
        server_name = "storopoli.com";
        address = [ "127.0.0.1" ];
        allow_registration = false;
        allow_encryption = true;
        allow_federation = true;
        trusted_servers = [
          "matrix.org"
          "continuwuity.org"
          "nixos.org"
          "nixbitcoin.org"
          "mozilla.org"
          "matrix.social.obscuravpn.io"
        ];
      };
    };
  };

  # Expose the Matrix client/federation HTTP API on the node's own MagicDNS name
  # (matrix.dojo-regulus.ts.net) over TLS-terminated TCP on :6167 with
  # Tailscale Serve.
  systemd.services.tailscale-serve =
    let
      tailscale = "${config.services.tailscale.package}/bin/tailscale";
    in
    {
      description = "Expose Matrix API over Tailscale Serve";
      after = [ "tailscaled.service" ];
      wants = [ "tailscaled.service" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${tailscale} serve --yes --bg --tls-terminated-tcp=6167 tcp://127.0.0.1:6167
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "5s";
        ExecStop = [ "-${tailscale} serve --yes --tls-terminated-tcp=6167 off" ];
      };
    };
}
