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
        set fish_key_bindings fish_vi_key_bindings

        # SSH GPG auth
        set -gx GPG_TTY (tty)
        set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
        gpgconf --launch gpg-agent

        # Theme Gruvbox
        theme_gruvbox dark hard
      ''
      + fishPath;

    shellAliases = {
      cat = "bat --style=plain";
      c = "cargo";
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

    functions = {
      compress = ''tar -czf "$argv[1].tar.gz" "$argv[1]'';
      webm2mp4 = ''
          if command -v ffmpeg >/dev/null 2>&1
              set input_file $argv[1]
              set output_file (string replace -r '\.webm$' '.mp4' $input_file)
              ffmpeg -i "$input_file" -c:v libx264 -preset slow -crf 22 -c:a aac -b:a 192k "$output_file"
        end
      '';
      cleanrust = ''
        if command -v fd >/dev/null 2>&1
            fd -It d -g target -X rm -rf
        end
      '';
      killport = ''
        if test (count $argv) -ne 1
            echo "Usage: killport <PORT>"
            echo ""
            echo "Kill the processes running on <PORT>"
            return 1
        end

        set PORT $argv[1]
        lsof -i "tcp:$PORT" | grep -v PID | awk '{print $2}' | xargs kill
      '';
    };
  };

  xdg.configFile = {
    "fish/functions/flakify.fish".source = ./functions/flakify.fish;
    "fish/functions/man.fish".source = ./functions/man.fish;
    "fish/functions/nixify.fish".source = ./functions/nixify.fish;
    "fish/functions/theme_gruvbox.fish".source = ./functions/theme_gruvbox.fish;
    "fish/functions/ytp.fish".source = ./functions/ytp.fish;
  };
}
