{
  pkgs,
  ...
}:

{
  home.packages = [
    pkgs.neovix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
    vimdiff = "nvim -d";
  };
}
