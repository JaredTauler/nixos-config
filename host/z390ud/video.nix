{
  config,
  pkgs,
  lib,
  ...
}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      egl-wayland
      rocmPackages.clr.icd
    ];
  };

  environment.systemPackages = with pkgs; [
    clinfo
    vulkan-tools
  ];

  hardware.enableRedistributableFirmware = true;

  # environment.sessionVariables = {
  #   AQ_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";

  #   AQ_NO_MODIFIERS = "1";
  #   AQ_FORCE_LINEAR_BLIT = "1";
  #   AQ_MGPU_NO_EXPLICIT = "1";
  # };

  boot.initrd.kernelModules = ["amdgpu"];

  # boot.kernelParams = [
  #   "nvidia_drm.fbdev=0"
  # ];

  services.xserver.videoDrivers = [
    "amdgpu"
    # "nvidia"
  ];

  # boot.blacklistedKernelModules = ["nouveau" "nvidiafb"];
  # hardware.nvidia = {
  #   prime = {
  #     offload = {
  #       enable = true;
  #       enableOffloadCmd = true;
  #     };

  #     nvidiaBusId = "PCI:1:0:0";
  #     amdgpuBusId = "PCI:6:0:0";
  #   };
  #   modesetting.enable = false;
  #   powerManagement.enable = false;

  #   powerManagement.finegrained = false;
  #   open = true;

  #   nvidiaSettings = true;
  # };

  # services.udev.extraRules = ''
  #   SUBSYSTEM=="drm", KERNEL=="card*", KERNELS=="0000:01:00.0", TAG-="seat"

  # '';

  environment.sessionVariables = {
  #   AQ_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";

  #   AQ_NO_MODIFIERS = "1";
  #   AQ_FORCE_LINEAR_BLIT = "1";
  #   AQ_MGPU_NO_EXPLICIT = "1";

    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_PATH = "$HOME/.nv/ShaderCache";
    __GL_SHADER_DISK_CACHE_SIZE = "16388608"; # 8 GB in KB
  };
}
