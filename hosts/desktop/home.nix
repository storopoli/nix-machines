{
  config,
  pkgs,
  username,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Follow the same stateVersion as the system
  home.stateVersion = config.system.stateVersion;

  # Gaming and desktop packages
  home.packages = with pkgs; [
    # System utilities

    # Gaming
    bottles
    mangohud
    protonup
  ];

  # Steam compatibility
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
