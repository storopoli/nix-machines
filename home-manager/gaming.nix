{
  pkgs-unstable,
  ...
}:

{
  # Gaming packages
  home.packages = with pkgs-unstable; [
    # Gaming
    bottles
    mangohud
    protonup
  ];

  # Steam compatibility
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
}
