{ ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        autoFetch = false;
        pagers = [
          {
            pager = ''delta --dark --paging=never --line-numbers --syntax-theme=gruvbox-dark --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"'';
            colorArg = "always";
          }
        ];
      };
    };
  };
}
