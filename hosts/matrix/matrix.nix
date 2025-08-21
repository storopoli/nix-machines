{ ... }:

{
  config = {
    # HTTP, HTTPS, Matrix federation, and Bridges
    networking.firewall.allowedTCPPorts = [
      80
      443
      8448
      6167
      8080
    ];

    services.matrix-continuwuity = {
      enable = true;
      settings = {
        global = {
          server_name = "storopoli.com";
          address = [ "0.0.0.0" ];
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
  };
}
