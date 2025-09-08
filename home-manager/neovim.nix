{
  pkgs,
  ...
}:

{
  home = {
    packages = [
      pkgs.neovix
    ];
    sessionVariables = {
      EDITOR = "nvim";
    };
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };
  };
}
