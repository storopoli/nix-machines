{
  config,
  pkgs,
  ...
}:

{
  # Nvidia Configuration
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vdpauinfo # sudo vainfo
        libva-utils # sudo vainfo
        # https://discourse.nixos.org/t/nvidia-open-breaks-hardware-acceleration/58770/2
        nvidia-vaapi-driver
        vaapiVdpau
        nvtopPackages.nvidia
        vulkan-tools # `vulkaninfo`, `vkcube`
        glxinfo # sanity check OpenGL
      ];
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  environment = {
    variables = {
      NVD_BACKEND = "direct";
      LIBVA_DRIVER_NAME = "nvidia";
      # CUDA
      CUDA_PATH = "${pkgs.cudatoolkit}";
    };
    systemPackages = with pkgs; [
      # CUDA
      cudaPackages.cudatoolkit
      cudaPackages.cudnn
    ];
  };
  boot.blacklistedKernelModules = [
    "nouveau"
    "i915"
  ];
}
