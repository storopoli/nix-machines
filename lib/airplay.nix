# <https://wiki.nixos.org/wiki/PipeWire#AirPlay/RAOP_configuration>
{ ... }:

{
  # avahi required for service discovery
  services.avahi.enable = true;

  services.pipewire = {
    # opens UDP ports 6001-6002
    raopOpenFirewall = true;

    extraConfig.pipewire = {
      "10-airplay" = {
        "context.modules" = [
          {
            name = "libpipewire-module-raop-discover";

            # increase the buffer size if you get dropouts/glitches
            # args = {
            #   "raop.latency.ms" = 500;
            # };
          }
        ];
      };
    };
  };

}
