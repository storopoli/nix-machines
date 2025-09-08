{
  nix-colors,
  ...
}:

let
  colorScheme = nix-colors.colorSchemes.gruvbox-dark-hard;
  inherit (colorScheme) palette;

  background-color = "#${palette.base00}";
  text-color = "#${palette.base05}";
  border-color = "#${palette.base04}";
  progress-color = "#${palette.base0D}";
in

{
  services.mako = {
    enable = true;

    settings = {
      inherit
        background-color
        text-color
        border-color
        progress-color
        ;

      width = 420;
      height = 110;
      padding = "10";
      margin = "10";
      border-size = 2;
      border-radius = 0;

      anchor = "top-right";
      layer = "overlay";

      default-timeout = 5000;
      ignore-timeout = false;
      max-visible = 5;
      sort = "-time";

      group-by = "app-name";

      actions = true;

      format = "<b>%s</b>\\n%b";
      markup = true;
    };
  };
}
