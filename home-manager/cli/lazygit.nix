{
  config,
  pkgs,
  lib,
  pkgs-unstable,
  ...
}:

{
  programs.lazygit = {
    enable = true;
    package = pkgs-unstable.lazygit;
    settings = {
      git = {
        autoFetch = false;
        paging = {
          colorArg = "always";
          pager = ''delta --dark --paging=never --line-numbers --syntax-theme=gruvbox-dark --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"'';
        };
      };
    };
  };
}
