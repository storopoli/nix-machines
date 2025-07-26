{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs = {
    bat = {
      enable = true;
      config = {
        italic-text = "always";
      };
    };
  };
}
