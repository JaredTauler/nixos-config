{ config, pkgs, lib,  ... }:
{

  environment.systemPackages = with pkgs; [
    libglvnd

    wayland
    wayland-protocols

    mesa

    egl-wayland
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      # For davinci resolve TODO
      # rocmPackages.clr.icd
      # amdvlk
      # mesa.drivers



    ];
  };


  

  # hardware.amdgpu = {
  #   # amdvlk = {
  #   #   enable = true;
  #   #   support32Bit.enable = true;
  #   # };
  #   #
  #   # opencl = {
  #   #   enable = true;
  #   # };
  # };

  #
  #
  #
  #TODO i dont think this does shit
  environment.sessionVariables = {
    WLR_DRM_DEVICES = "/dev/dri/by-path/pci-0000:05:00.0-card";
    # LD_LIBRARY_PATH = lib.mkBefore "/run/opengl-driver/lib:/run/opengl-driver-32/lib:";
  };

  services.xserver.videoDrivers = ["amdgpu""nvidia"];

  boot = {
    kernelModules  = [ "nvidia" "nvidia-drm" ];
    kernelParams   = [ "nvidia_drm.fbdev=0" ];               # keep fb fix
  };

  hardware.nvidia = {
      prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:5:0:0";
  };
    modesetting.enable = false;
    powerManagement.enable = true;

   powerManagement.finegrained = false;
    open = true;

   nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # hardware.steam-hardware.enable = true;

  # hardware.pulseaudio = {
  #   enable = false;
  #   extraConfig = ''
  #     	load-module module-remap-sink sink_name=remap surround40:FL,FR,SL,SR
  #   '';
  # };
  #
  #


boot.blacklistedKernelModules = [ "nvidia" "nvidia_drm" "nvidia_modeset" "nvidia_uvm" ];

environment.etc."environment.d/10-amd-gpu.conf".text = ''
  WLR_DRM_DEVICES=/dev/dri/by-path/pci-0000:05:00.0-card
'';

# Put nvidia card on its own seat
services.udev.extraRules = ''
  # Put every NVIDIA DRM device on its own seat the compositor never touches
  SUBSYSTEM=="drm", KERNEL=="card*",    ATTRS{vendor}=="0x10de", ENV{ID_SEAT}="seat-nvidia"
  SUBSYSTEM=="drm", KERNEL=="renderD*", ATTRS{vendor}=="0x10de", ENV{ID_SEAT}="seat-nvidia"
'';

}
