{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    # Core dependencies
    ripgrep
    fd
    fzf

    # Language servers
    # rust-analyzer # conflicts with rustup
    marksman
    nil
    haskell-language-server
    bash-language-server
    fish-lsp
    vscode-langservers-extracted
    pyright
    ruff
    # rust-analyzer # conflicts with rustup
    taplo
    tinymist
    yaml-language-server
    lua-language-server
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    package = pkgs-unstable.neovim-unwrapped;

    plugins = with pkgs-unstable.vimPlugins; [
      gruvbox-nvim
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
      nvim-treesitter-textobjects
      mini-pick
      mini-extra
      mini-surround
      nvim-lspconfig
      gitsigns-nvim
      typst-preview-nvim
    ];

    extraLuaConfig = lib.readFile ./init.lua;
  };
}
