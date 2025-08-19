{
  pkgs-unstable,
  ...
}:

let
  wallpaper_path = "~/.wallpapers/gruvbox-dark-blue.webp";
in

{
  services.hyprpaper = {
    enable = true;
    package = pkgs-unstable.hyprpaper;
    settings = {
      preload = [
        wallpaper_path
      ];
      wallpaper = [
        ",${wallpaper_path}"
      ];
    };
  };
}
