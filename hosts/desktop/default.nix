{ module, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./${module}.nix
    ../../lib/doas.nix
    ../../lib/dns.nix
    ../../lib/audio.nix
    ../../lib/bluetooth.nix
    ../../lib/airplay.nix
    ../../lib/nvidia.nix
  ];
}
