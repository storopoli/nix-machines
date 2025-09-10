{
  pkgs,
  inputs,
  ...
}:

{
  home = {
    packages = [
      inputs.neovix.packages.${pkgs.system}.default
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
