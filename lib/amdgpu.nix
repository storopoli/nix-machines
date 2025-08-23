{ ... }:

{
  services.xserver.videoDrivers = [ "modesetting" ];

  hardware = {

    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu.initrd.enable = true;
  };
}
