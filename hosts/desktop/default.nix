{ module, inputs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./bluetooth.nix
    ./${module}.nix
  ];
}
