{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tailscale;
in {
  options.services.tailscale = {
    enable = mkEnableOption "Tailscale client daemon";

    authKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to file containing the auth key.
        If null, no auth key is used.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Configure sops
    sops = {
      age.keyFile = "/var/lib/sops/age/keys.txt";
      gnupg.sshKeyPaths = [];
    };

    # Configure sops to decrypt the auth key
    sops.secrets.tailscale = {
      sopsFile = ../secrets/tailscale.yaml;
      owner = config.users.users.root.name;
      group = config.users.users.root.group;
    };

    services.tailscale = {
      # Enable the Tailscale service
      enable = true;

      # Set the auth key file to the decrypted secret
      authKeyFile = config.sops.secrets.tailscale.path;

      # Open the firewall port
      openFirewall = true;

      # Reverse path filtering will be set to loose and IP forwarding will be enabled.
      useRoutingFeatures = "both";

      # Enable SSH
      extraUpFlags = [
        "--ssh"
      ];
    };
  };
}