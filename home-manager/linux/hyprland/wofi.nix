{
  nix-colors,
  pkgs-unstable,
  ...
}:

let
  colorScheme = nix-colors.colorSchemes.gruvbox-dark-hard;
  palette = colorScheme.palette;

  background-color = palette.base00;
  text-color = palette.base06;
  entry-color = palette.base02;
in

{
  home.file = {
    ".config/wofi/style.css" = {
      text = ''
        * {
          font-family: 'CaskaydiaMono Nerd Font', monospace;
          font-size: 18px;
        }

        window {
          margin: 0px;
          padding: 20px;
          background-color: #${background-color};
          opacity: 0.95;
        }

        #inner-box {
          margin: 0;
          padding: 0;
          border: none;
          background-color: #${background-color};
        }

        #outer-box {
          margin: 0;
          padding: 20px;
          border: none;
          background-color: #${background-color};
        }

        #scroll {
          margin: 0;
          padding: 0;
          border: none;
          background-color: #${background-color};
        }

        #input {
          margin: 0;
          padding: 10px;
          border: none;
          background-color: #${background-color};
          color: @text;
        }

        #input:focus {
          outline: none;
          box-shadow: none;
          border: none;
        }

        #text {
          margin: 5px;
          border: none;
          color: #${text-color};
        }

        #entry {
          background-color: #${background-color};
        }

        #entry:selected {
          outline: none;
          border: none;
        }

        #entry:selected #text {
          color: #${entry-color};
        }

        #entry image {
          -gtk-icon-transform: scale(0.7);
        }
      '';
    };
  };

  programs.wofi = {
    enable = true;
    package = pkgs-unstable.wofi;
    settings = {
      width = 600;
      height = 350;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
    };
  };
}
