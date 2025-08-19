{
  pkgs,
  ...
}:

let
  flavor = "gruvbox-dark";
in

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;

    flavors.${flavor} = pkgs.stdenv.mkDerivation {
      pname = "yazi-flavor-${flavor}";
      version = "2025-07-31";
      src = ./gruvbox-dark.toml;
      unpackPhase = ":";
      installPhase = ''
        mkdir -p $out/
        cp $src $out/flavor.toml
      '';
    };
    theme.flavor.dark = "gruvbox-dark";
  };
}
