{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  # Use the continuwuity package directly from the flake input
  continuwuity = inputs.continuwuity.packages.${pkgs.system}.default;
in
{
  # HTTP, HTTPS, Matrix federation, and Bridges
  config.networking.firewall.allowedTCPPorts = [
    80
    443
    8448
    6167
    8080
  ];

  # Use the Continuwuity NixOS module directly if available, otherwise use the Conduit module
  config.services = {
    matrix-conduit = {
      enable = true;
      package = continuwuity;
      settings = {
        global = {
          server_name = "storopoli.com"; # Change to your actual domain
          # Continuwuity requires RocksDB backend
          database_backend = "rocksdb";
          # Uncomment for UNIX socket configuration
          # unix_socket_path = "/run/continuwuity/continuwuity.sock";
          # Comment out address and port when using UNIX socket
          address = "0.0.0.0";
          port = 6167;
        };
      };
    };
  };

  # Allow UNIX sockets if needed
  options.services.matrix-conduit.settings = lib.mkOption {
    apply =
      old:
      old
      // (
        if (old.global ? "unix_socket_path") then
          {
            global = builtins.removeAttrs old.global [
              "address"
              "port"
            ];
          }
        else
          { }
      );
  };

  # The matrix-conduit systemd unit in the module does not allow the AF_UNIX
  # socket address family in their systemd unit's RestrictAddressFamilies= which
  # disallows the namespace from accessing or creating UNIX sockets and has to be enabled
  # manually.
  config.systemd.services.conduit.serviceConfig.RestrictAddressFamilies = [ "AF_UNIX" ];
}
