{
  pkgs,
  ...
}:

{
  services = {
    # GNOME Desktop Environment
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # NVIDIA support
    videoDrivers = [ "nvidia" ];

    # minimal gnome
    gnome = {
      core-apps.enable = false;
      core-developer-tools.enable = false;
      games.enable = false;
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
  };
}
