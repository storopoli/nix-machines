{ module, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./${module}.nix
    ../../lib/dns.nix
    ../../lib/audio.nix
    ../../lib/bluetooth.nix
    ../../lib/nvidia.nix
  ];
}
