# Module that holds all tailscale related config
{ username, config, ... }: {
  networking.firewall = {
    # enable the firewall
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];

    # let you SSH in over the public internet
    allowedTCPPorts = [ 22 ];
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets.tailscale.path;
  };

  # Configure sops
  sops = {
    age.keyFile = "/var/lib/sops/age/keys.txt";

    defaultSopsFile = ../secrets/tailscale.yaml;

    secrets.tailscale = {
      owner = username;
      inherit (config.users.users.${username}) group;
    };

  };

}
