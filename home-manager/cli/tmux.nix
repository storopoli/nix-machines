{ pkgs, ... }:

{
  programs = {
    tmux = {
      enable = true;
      terminal = "ghostty";
      shell = "${pkgs.fish}/bin/fish";
      historyLimit = 100000;
      mouse = true;
      keyMode = "vi";
      escapeTime = 5;
      baseIndex = 1;
      shortcut = "a";
      # terminal = "xterm-256color";
      plugins = with pkgs.tmuxPlugins; [
        {
          # https://github.com/egel/tmux-gruvbox
          # Gruvbox colorscheme
          plugin = gruvbox;
          extraConfig = ''
            set -g @tmux-gruvbox "dark"
            set -g @tmux-gruvbox-statusbar-alpha "true"
          '';
        }
        {
          # https://github.com/tmux-plugins/tmux-yank
          # Tmux plugin for copying to system clipboard.
          plugin = yank;
        }
        {
          # https://github.com/tmux-plugins/tmux-resurrect
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-capture-pane-contents 'on' 
            set -g @resurrect-processes ':all:'
          '';
        }
        {
          # https://github.com/tmux-plugins/tmux-continuum
          # Continuous saving of tmux environment.
          # Automatic restore when tmux is started.
          # Automatic tmux start when computer is turned on.
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-save-interval '120'
            set -g @continuum-restore 'on'
          '';
        }
        {
          # https://github.com/tmux-plugins/tmux-pain-control
          # standard pane key-bindings for tmux
          plugin = pain-control;
          extraConfig = ''
            # Focus events enabled for terminals that support them
            set -g focus-events on

            # Super useful when using "grouped sessions" and multi-monitor setup
            setw -g aggressive-resize on

            # Give back my C-a C-a (vim)
            unbind C-a
            bind-key C-a send-prefix
          '';
        }
      ];
      extraConfig = ''
        # Fix color and cursor
        set -ag terminal-overrides ",xterm*:Tc,xterm*:Se=\e[0 q"
      '';
    };
  };
}
