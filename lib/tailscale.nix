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
    };
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
    # authKeyFile = /tmp/tailscale.key;
  };
}
