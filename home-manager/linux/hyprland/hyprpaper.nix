{
  username,
  ...
}:

let
  wallpaper_path = "/home/${username}/.wallpapers/gruvbox-dark-blue.webp";
in

{
  services.hyprpaper = {
    enable = true;
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
