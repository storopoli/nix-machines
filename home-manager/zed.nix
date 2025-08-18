{ pkgs-unstable, ... }:

{
  programs.zed-editor = {
    enable = true;
    package = pkgs-unstable.zed-editor;
    extensions = [
      "nix"
      "catppuccin"
      "catppuccin-icons"
      "git-firefly"
      "haskell"
      "typst"
      "julia"
      "zig"
      "just"
      "typos"
    ];
    userSettings = {
      project_panel = {
        hide_gitignore = true;
      };

      ui_font_size = 16;
      buffer_font_size = 13;
      buffer_font_family = "Zed Plex Mono";
      buffer_font_features = {
        calt = false; # Disable ligatures
      };

      auto_signature_help = true;
      restore_on_startup = "none";

      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      use_smartcase_search = true;
      vim_mode = true;
      relative_line_numbers = true;
      vertical_scroll_margin = 8;

      vim = {
        use_system_clipboard = "never";
        toggle_relative_line_numbers = true;
        highlight_on_yank_duration = 100;
      };

      terminal = {
        shell = {
          program = "fish";
        };
      };

      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = true;
        show_other_hints = true;
      };

      theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };

      icon_theme = "Catppuccin Mocha";

      features = {
        edit_prediction_provider = "copilot";
      };

      agent = {
        default_model = {
          provider = "anthropic";
          model = "claude-opus-4-1-thinking-latest";
        };
        inline_assistant_model = {
          provider = "anthropic";
          model = "claude-sonnet-4-latest";
        };
      };

      calls = {
        mute_on_join = true;
      };
    };
  };
}
