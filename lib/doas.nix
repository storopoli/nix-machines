# <https://wiki.nixos.org/wiki/Doas>
{ username, ... }:

{
  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [
    {
      users = [ "${username}" ];
      # Optional, retains environment variables while running commands
      # e.g. retains your NIX_PATH when applying your config
      keepEnv = true;
      persist = true; # Optional, don't ask for the password for some time, after a successfully authentication
    }
  ];
}
