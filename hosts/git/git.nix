{
  pkgs,
  config,
  username,
  lib,
  ...
}:

{
  config.services.forgejo = {
    enable = true;
    database.type = "postgres";
    settings = {
      server = {
        DOMAIN = "git.storopoli.com";
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://git.storopoli.com/";
        HTTP_PORT = 3000;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;
    };
  };
}
