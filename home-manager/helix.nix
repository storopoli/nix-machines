{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.helix = {
    enable = true;

    defaultEditor = true;

    extraPackages = with pkgs; [
      # LSP
      marksman
      nil
      haskell-language-server
      bash-language-server
      fish-lsp
      vscode-langservers-extracted
      pyright
      ruff
      rust-analyzer
      taplo
      tinymist
      yaml-language-server

      # Formatter
      nixfmt-rfc-style
      fourmolu
      haskellPackages.cabal-fmt
      shfmt

      # Debugger
      lldb # provides lldb-vscode
    ];

    settings = {
      theme = "gruvbox_dark_hard";

      editor = {
        line-number = "relative";
        mouse = true;
        scrolloff = 8;
        cursorline = true;
        rulers = [ 80 ];
        true-color = true;
        color-modes = true;
        completion-trigger-len = 1;
        idle-timeout = 50;
        bufferline = "multiple";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
        statusline = {
          left = [
            "mode"
            "spinner"
            "version-control"
          ];
          center = [ "file-name" ];
          right = [
            "workspace-diagnostics"
            "selections"
            "position-percentage"
            "position"
            "file-encoding"
            "file-type"
          ];
        };
        indent-guides = {
          render = true;
          character = "╎";
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
      };

      keys = {
        normal = {
          Cmd-s = ":write";
          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];
          A-x = "extend_to_line_bounds";
          X = [
            "extend_line_up"
            "extend_to_line_bounds"
          ];
          A-g = ":reset-diff-change";
          # lazygit integration: https://github.com/helix-editor/helix/discussions/12045
          C-g = [
            ":write-all"
            ":new"
            ":insert-output lazygit >/dev/tty"
            ":set mouse false"
            ":set mouse true"
            ":buffer-close!"
            ":redraw"
            ":reload-all"
          ];
          # yazi integration: https://github.com/helix-editor/helix/discussions/12934
          C-y = [
            ":sh rm -f /tmp/files2open"
            ":set mouse false"
            '':insert-output yazi "%{buffer_name}" --chooser-file=/tmp/files2open''
            ":redraw"
            ":set mouse true"
            ":open /tmp/files2open"
            "select_all"
            "split_selection_on_newline"
            "goto_file"
            ":buffer-close! /tmp/files2open"
          ];
          # Swap lines up and down
          A-j = [
            "ensure_selections_forward"
            "extend_to_line_bounds"
            "extend_char_right"
            "extend_char_left"
            "delete_selection"
            "add_newline_below"
            "move_line_down"
            "replace_with_yanked"
          ];
          A-k = [
            "ensure_selections_forward"
            "extend_to_line_bounds"
            "extend_char_right"
            "extend_char_left"
            "delete_selection"
            "move_line_up"
            "add_newline_above"
            "move_line_up"
            "replace_with_yanked"
          ];
          space = {
            w = ":write";
            q = ":quit";
            Q = ":quit-all!";
            space = "buffer_picker";
            # Generate permalink for current line
            # o = [":sh echo \"$(git remote get-url origin | sed 's/\\.git$//' | sed 's/git@github\\.com:/https:\\/\\/github\\.com\\//')/blob/$(git rev-parse HEAD)/%{buffer_name}#L%{cursor_line}\" | pbcopy"];
            o = [
              ":sh echo \"$(git remote get-url origin | sed 's/\\.git$//' | sed 's/git@github\\.com:/https:\\/\\/github\\.com\\//')/blob/$(git rev-parse HEAD)/%{buffer_name}#L%{selection_line_start}-L%{selection_line_end}\" | pbcopy"
            ];
          };
        };
        select = {
          X = [
            "extend_line_up"
            "extend_to_line_bounds"
          ];
          A-x = "extend_to_line_bounds";
          A-g = ":reset-diff-change";
          space = {
            # Generate permalink for current selection line range
            o = [
              ":sh echo \"$(git remote get-url origin | sed 's/\\.git$//' | sed 's/git@github\\.com:/https:\\/\\/github\\.com\\//')/blob/$(git rev-parse HEAD)/%{buffer_name}#L%{selection_line_start}-L%{selection_line_end}\" | pbcopy"
            ];
          };
        };
      };
    };

    languages = {
      language-server = {
        haskell-language-server.config = {
          formattingProvider = "fourmolu";
          cabalFormattingProvider = "cabal-fmt";
          plugin = {
            fourmolu.config.external = true;
            rename.config.crossModule = true;
          };
        };

        tinymist.config = {
          tinymist.formatterMode = "typstyle";
        };

        yaml-language-server.config = {
          yaml = {
            format = {
              enable = true;
            };
            validation = true;
            schemas = {
              "kubernetes" = "*.yaml";
              "https=//raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
                "docker-compose.yaml";
              "https=//json.schemastore.org/github-workflow.json" = ".github/workflows/*.yaml";
              "https=//json.schemastore.org/github-action.json" = ".github/actions/*/action.yaml";
            };
          };
        };
      };
      language = [
        {
          name = "nix";
          formatter = {
            command = "nixfmt";
          };
          auto-format = true;
        }

        {
          name = "haskell";
          auto-format = true;
        }

        {
          name = "toml";
          formatter = {
            command = "taplo";
            args = [
              "fmt"
              "-"
            ];
          };
          auto-format = true;
        }

        {
          name = "python";
          language-servers = [
            "pyright"
            "ruff"
          ];
          formatter = {
            command = "sh";
            args = [
              "-c"
              "ruff format - | ruff check --select I --fix - "
            ];
          };
          auto-format = true;
        }

        {
          name = "bash";
          formatter = {
            command = "shfmt";
            args = [
              "-i"
              "2"
              "-"
            ];
          };
          auto-format = true;
        }

        {
          name = "typst";
          auto-format = true;
        }

      ];
    };
  };
}
