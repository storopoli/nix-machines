{
  pkgs,
  lib,
  nvidia ? false,
  ...
}:

{
  services = {
    # GNOME Desktop Environment
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # minimal gnome
    gnome = {
      core-apps.enable = false;
      core-developer-tools.enable = false;
      games.enable = false;
    };

  }
  // lib.optionalAttrs nvidia {
    # NVIDIA support
    xserver.videoDrivers = [ "nvidia" ];
  };

  environment.systemPackages = with pkgs; [
    nautilus
    loupe
    snapshot
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    geary
  ];
}
