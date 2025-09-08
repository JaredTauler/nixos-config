{ config, pkgs, lib,  ... }:
{

  environment.systemPackages = with pkgs; [
    libglvnd

    wayland
    wayland-protocols

    # mesa

    egl-wayland


    # config.boot.kernelPackages.nvidiaPackages.beta.out
    # config.boot.kernelPackages.nvidiaPackages.beta.lib32

  ];
  #  boot.blacklistedKernelModules = [
    # AMD
    #    "amdgpu" "radeon"];

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


    #TODO i dont think this does shit
    environment.sessionVariables = {
      # NVIDIA_ICD_JSON = "${config.boot.kernelPackages.nvidiaPackages.beta.out}/share/vulkan/icd.d/nvidia_icd.x86_64.json";
      # AQ_DRM_DEVICES  = "/dev/dri/by-path/pci-0000:05:00.0-card:/dev/dri/by-path/pci-0000:01:00.0-card";
      # WLR_DRM_DEVICES = "/dev/dri/by-path/pci-0000:05:00.0-card:/dev/dri/by-path/pci-0000:01:00.0-card";
      # WLR_DRM_NO_MODIFIERS="1";
      WLR_DRM_DEVICES = "/dev/dri/by-path/pci-0000:05:00.0-card";
      # AQ_DRM_DEVICES = "/dev/dri/by-path/pci-0000:05:00.0-card";
      # WLR_DRM_DEVICES = "/dev/dri/by-path/pci-0000:01:00.0-card";

      # WLR_RENDERER="vulkan";
      # LD_LIBRARY_PATH = lib.mkBefore "/run/opengl-driver/lib:/run/opengl-driver-32/lib:";
    };

    services.xserver.videoDrivers = [
      "amdgpu"
      "nvidia"
    ];

    # boot = {
      #   #     kernelModules  = [ "nvidia" "nvidia-drm" ];
      #       kernelParams   = [ "nvidia_drm.fbdev=0" ];               # keep fb fix
      #     };
      boot.kernelParams = [
        "video=efifb:off"
      ];
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
        # package = config.boot.kernelPackages.nvidiaPackages.beta;
      };

      # boot.kernelParams = [ "nvidia_drm.modeset=1" ];


      #   # hardware.pulseaudio = {
        #   #   enable = false;
        #   #   extraConfig = ''
        #   #     	load-module module-remap-sink sink_name=remap surround40:FL,FR,SL,SR
        #   #   '';
        #   # };
        #   #
        #   #


        # services.udev.extraRules = ''
        #   SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="0x10de", TAG-="seat"
        #   SUBSYSTEM=="drm", KERNEL=="renderD*", ATTRS{vendor}=="0x10de", TAG-="seat"
        # '';
}
