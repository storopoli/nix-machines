{
  lib,
  ...
}:

{
  # GNOME Desktop Environment
  # TODO: in 25.11 these will change
  #       see <https://wiki.nixos.org/wiki/GNOME>
  services.xserver = {
    enable = lib.mkForce true;
    displayManager.gdm.enable = lib.mkForce true;
    desktopManager.gnome.enable = lib.mkForce true;
    videoDrivers = [ "nvidia" ];
  };
}
