{ pkgs, username, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  fishPath =
    if isDarwin then
      ''
        # fish path stuff
        fish_add_path /run/current-system/sw/bin
        fish_add_path /nix/var/nix/profiles/default/bin
        fish_add_path ~/.nix-profile/bin
        fish_add_path /etc/profiles/per-user/${username}/bin
        fish_add_path /opt/homebrew/bin
        fish_add_path ~/.cargo/bin
        fish_add_path ~/.npm-global/bin
        fish_add_path ~/.local/bin
        fish_add_path ~/.cabal/bin
        fish_add_path ~/.sp1/bin
        fish_add_path ~/.risc0/bin
        fish_add_path /opt/homebrew/opt/llvm/bin
      ''
    else
      ''
        # fish path stuff
        fish_add_path /etc/profiles/per-user/${username}/bin
        fish_add_path ~/.cargo/bin
        fish_add_path ~/.npm-global/bin
        fish_add_path ~/.local/bin
        fish_add_path ~/.cabal/bin
        fish_add_path ~/.sp1/bin
        fish_add_path ~/.risc0/bin
      '';
in

{
  programs.fish = {
    enable = true;

    interactiveShellInit =
      ''
        # Disable greeting
        set fish_greeting

        # VI key bindings
        if set -q INSIDE_NEOVIM
            set fish_key_bindings fish_default_key_bindings
        else
            set fish_key_bindings fish_vi_key_bindings
        end

        # SSH GPG auth
        set -gx GPG_TTY (tty)
        set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
        gpgconf --launch gpg-agent

        # man bat integration
        set -x MANPAGER 'sh -c "col -bx | bat --language=man --decorations=never"'
        set -x MANROFFOPT '-c'

        # TODO: 25.11 will have `programs.fish.binds`
        # binds
        bind ctrl-n -M insert down-or-search
        bind ctrl-p -M insert up-or-search
        bind ctrl-g -M insert 'git diff' repaint

        # Theme Gruvbox
        theme_gruvbox dark hard
      ''
      + fishPath;

    shellAliases = {
      cat = "bat --style=plain";
      c = "cargo";
      curl = "curl -fSsL --proto '=https' --tlsv1.3"; # tinfoil-hat
      cd = "z";
      ff = "fzf --preview 'bat --style=numbers --color=always {}'";
      g = "git";
      gcm = "git commit -m";
      gcam = "git commit -a -m";
      gcad = "git commit -a --amend";
      lg = "lazygit";
      rebuild = "doas nixos-rebuild switch --flake .#";
      testtor = "curl -x socks5h://localhost:9050 -s https://check.torproject.org/api/ip";
      testmullvad = "curl -Ls am.i.mullvad.net/json | jq";
      y = "yazi";
      yt = "yt-dlp --add-metadata -i --format mp4 --restrict-filenames";
      yta = "yt -x -f bestaudio/best --format mp4 --audio-format opus --restrict-filenames";
    };

    # TODO: 25.11 will have `programs.fish.binds`
    # binds = {
    #   "ctrl-n" = {
    #     command = "down-or-search";
    #     mode = "insert";
    #   };
    #   "ctrl-p" = {
    #     command = "up-or-search";
    #     mode = "insert";
    #   };
    #   "ctrl-g" = {
    #     command = "'git diff' repaint";
    #     mode = "insert";
    #   };
    # };
  };

  xdg.configFile = {
    "fish/functions/compress.fish".source = ./functions/compress.fish;
    "fish/functions/killport.fish".source = ./functions/killport.fish;
    "fish/functions/webm2mp4.fish".source = ./functions/webm2mp4.fish;
    "fish/functions/ytp.fish".source = ./functions/ytp.fish;

    "fish/functions/flakify.fish".source = ./functions/flakify.fish;
    "fish/functions/nixify.fish".source = ./functions/nixify.fish;
    "fish/functions/cleanrust.fish".source = ./functions/cleanrust.fish;

    "fish/functions/theme_gruvbox.fish".source = ./functions/theme_gruvbox.fish;
  };
}
