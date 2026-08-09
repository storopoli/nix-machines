# <https://wiki.nixos.org/wiki/Doas>
{
  username,
  ...
}:

{
  security = {
    doas.enable = true;
    sudo.enable = false;
    doas.extraRules = [
      {
        users = [ "${username}" ];
        # Keys-only access model: no local password prompts.
        noPass = true;
        persist = false;
      }
    ];
  };
  environment.shellAliases.sudo = "doas";
}
