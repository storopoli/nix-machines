# Module that holds all tailscale related config
{
  config,
  ...
}:
{
  networking = {
    # MagicDNS
    # <https://tailscale.com/download/linux/nixos#using-magicdns>
    nameservers = [
      "100.100.100.100"
      "1.1.1.1"
      "8.8.8.8"
    ];
    search = [ "dojo-regulus.ts.net" ];
    firewall = {
      # enable the firewall
      enable = true;

      # always allow traffic from your Tailscale network
      trustedInterfaces = [ "tailscale0" ];

      # allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [ config.services.tailscale.port ];

      # let you SSH in over the public internet
      allowedTCPPorts = [ 22 ];
    };
  };

  services.tailscale = {
    enable = true;
    # authKeyFile = /tmp/tailscale.key;
  };
}
