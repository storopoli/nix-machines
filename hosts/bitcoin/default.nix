{ module, inputs, ... }:
{
  imports = [
    # ./disko.nix
    ./hardware-configuration.nix
    ./${module}.nix
  ];
}
