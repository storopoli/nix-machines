{
  config,
  lib,
  tailscaleName,
  ...
}:

let
  forgejoDomain = "${config.networking.hostName}.${tailscaleName}.ts.net";
in
{
  # Configure Tailscale hostname
  services.tailscale.extraUpFlags = lib.mkAfter [ "--hostname=git" ];

  services.forgejo = {
    enable = true;
    database.type = "postgres";
    settings = {
      server = {
        DOMAIN = forgejoDomain;
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://${forgejoDomain}/";
        HTTP_PORT = 3000;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;
    };
  };

  # Expose Forgejo publicly on the node's own MagicDNS name over HTTPS with
  # Tailscale Funnel.
  systemd.services.tailscale-funnel =
    let
      tailscale = "${config.services.tailscale.package}/bin/tailscale";
      forgejo = config.services.forgejo.settings.server;
    in
    {
      description = "Expose Forgejo over Tailscale Funnel";
      after = [
        "tailscaled.service"
        "forgejo.service"
      ];
      wants = [
        "tailscaled.service"
        "forgejo.service"
      ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${tailscale} funnel --yes --bg --https=443 http://127.0.0.1:${toString forgejo.HTTP_PORT}
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "5s";
        ExecStop = [ "-${tailscale} funnel --yes --https=443 off" ];
      };
    };
}
