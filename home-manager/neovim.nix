{
  pkgs,
  inputs,
  ...
}:

{
  home.packages = [
    inputs.neovix.packages.${pkgs.system}.default
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
