{ config, pkgs, lib,  ... }:
{

      hardware.graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [
          # For davinci resolve TODO
          # rocmPackages.clr.icd
          # amdvlk
          # mesa.drivers
          egl-wayland
          rocmPackages.clr.icd
          # amdvlk

        ];
      };

      environment.variables = {
        ROC_ENABLE_PRE_VEGA = "1";
      };

      # hardware.graphics.extraPackages32 = with pkgs; [
      #   driversi686Linux.amdvlk
      # ];

      environment.systemPackages = with pkgs; [
        clinfo
      ];

      hardware.enableRedistributableFirmware = true;


      environment.sessionVariables = {
        # Keep hyprland from running like dogshit
        AQ_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
        # WLR_DRM_DEVICES = "/dev/dri/by-path/pci-0000:01:00.0-card";

        AQ_NO_MODIFIERS="1";
        AQ_FORCE_LINEAR_BLIT = "1";
        AQ_MGPU_NO_EXPLICIT  = "1";
      };


        boot.initrd.kernelModules = [ "amdgpu" ];



        # boot.initrd.preDeviceCommands = ''
        #   modprobe -r nvidia_drm 2>/dev/null || true
        #   modprobe -r nvidia_modeset 2>/dev/null || true
        #   modprobe -r nvidia 2>/dev/null || true
        # '';

        # boot.initrd.extraModprobeConfig = ''
        #   options nvidia_drm modeset=0 fbdev=0
        # '';

        # boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];
        boot.kernelParams = [
          # "video=efifb:off"
          # "nvidia_drm.modeset=0" 
          "nvidia_drm.fbdev=0"
          # "fbcon=map:11111111"
        ];



        services.xserver.videoDrivers = [
          "amdgpu"
          "nvidia"
        ];

        
        boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];
        hardware.nvidia = {
          prime = {
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };

            nvidiaBusId = "PCI:1:0:0";
            amdgpuBusId = "PCI:6:0:0";
          };
          modesetting.enable = false;
          powerManagement.enable = true;

          powerManagement.finegrained = false;
          open = true;

          nvidiaSettings = true;

          # Optionally, you may need to select the appropriate driver version for your specific GPU.
          # package = config.boot.kernelPackages.nvidiaPackages.beta;
        };

        # Keep nvidia card off any seat
        services.udev.extraRules = ''
          SUBSYSTEM=="drm", KERNEL=="card*", KERNELS=="0000:01:00.0", TAG-="seat"

        '';


        #   # hardware.pulseaudio = {
          #   #   enable = false;
          #   #   extraConfig = ''
          #   #     	load-module module-remap-sink sink_name=remap surround40:FL,FR,SL,SR
          #   #   '';
          #   # };
          #   #
          #   #


          # ACTION=="add|change", SUBSYSTEM=="drm", KERNEL=="card*", DRIVERS=="amdgpu", \
          # ATTR{device/power_dpm_force_performance_level}="high"
          # '';


          # FIXME figure out how to remember vulkan shaders 
          environment.sessionVariables = {
              __GL_SHADER_DISK_CACHE = "1";
              __GL_SHADER_DISK_CACHE_PATH = "$HOME/.nv/ShaderCache";
              __GL_SHADER_DISK_CACHE_SIZE = "16388608"; # 8 GB in KB
            };


}
