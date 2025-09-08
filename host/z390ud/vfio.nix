# boot = {
  #   initrd.kernelModules = [
    #     "vfio_pci"
    #     "vfio"
    #     "vfio_iommu_type1"
    #   ];
    #   blacklistedKernelModules = [ "nvidia" "nvidia_drm" "nvidia_modeset" "nvidia_uvm" "nouveau"];

    #   # Strongest binding + disable firmware framebuffers on NVIDIA
    #   kernelParams = [
      #     "intel_iommu=on" "iommu=pt"
      #     "pcie_aspm=off"
      #     # Bind all 4 functions of the TU104 device to vfio-pci in initrd
      #     "vfio-pci.ids=10de:1e89,10de:10f8,10de:1ad8,10de:1ad9"
      #     # Extra belt-and-suspenders: keep nvidia/nouveau out everywhere
      #     "module_blacklist=nvidia,nvidia_drm,nvidia_modeset,nvidia_uvm,nouveau"
      #     # Kill firmware/simple DRM so NVIDIA can't show a boot picture
      #     "video=efifb:off"
      #     "simpledrm=0"
      #   ];

      #   # # (Optional) also set via modprobe for post-initrd consistency
      #   # extraModprobeConfig = ''
      #   #   options vfio-pci ids=10de:1e89,10de:10f8,10de:1ad8,10de:1ad9 disable_vga=1
      #   # '';
      #   postBootCommands = ''
      #     DEVS="0000:01:00.0 0000:01:00.1"

      #     for DEV in $DEVS; do
      #     echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
      #     done
      #     modprobe -i vfio-pci
      #   '';
      # };


      let
        gpuIDs = [
          "10de:1e89"
          "10de:10f8"
          "10de:1ad8"
          "10de:1ad9"
        ];
      in { pkgs, lib, config, ... }: {
        options.vfio.enable = with lib;
        mkEnableOption "Configure the machine for VFIO";

        config = let cfg = config.vfio;
        in {
          boot = {
            initrd.kernelModules = [
              "vfio_pci"
              "vfio"
              "vfio_iommu_type1"
               # "vfio_virqfd" 


              # "nvidia"
              # "nvidia_modeset"
              # "nvidia_uvm"
              # "nvidia_drm"
            ];

            # extraModprobeConfig = ''
            #   options vfio-pci ids=${lib.concatStringsSep "," gpuIDs} disable_vga=1
            # '';

            kernelParams = [
              "intel_iommu=on" "iommu=pt"
              "pcie_aspm=off"
            ];
            # ] ++ lib.optional cfg.enable
            # # isolate the GPU
            # ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
            # blacklistedKernelModules = [
            #   "nouveau"
            #   "nvidia" "nvidia_drm" "nvidia_modeset" "nvidia_uvm" "nvidiafb"
            #   # NOTE: do NOT blacklist snd_hda_intel globally;
            #   # vfio will already claim 10de:10f8 before it can.
            # ];

            # initrd.preDeviceCommands = ''
            #   for dev in 0000:01:00.0 0000:01:00.1 0000:01:00.2 0000:01:00.3; do
            #   if [ -e /sys/bus/pci/devices/$dev/driver_override ]; then
            #   echo vfio-pci > /sys/bus/pci/devices/$dev/driver_override
            #   fi
            #   done
            # '';

            # initrd.postDeviceCommands = lib.mkIf cfg.enable ''
            #   for fn in 0000:01:00.0 0000:01:00.1 0000:01:00.2 0000:01:00.3; do
            #   [ -e /sys/bus/pci/devices/$fn ] || continue
            #   if [ -e /sys/bus/pci/devices/$fn/driver ]; then
            #   echo $fn > /sys/bus/pci/devices/$fn/driver/unbind || true
            #   fi
            #   echo vfio-pci > /sys/bus/pci/devices/$fn/driver_override
            #   echo $fn > /sys/bus/pci/drivers/vfio-pci/bind || true
            #   done
            # '';
          };

          # hardware.opengl.enable = true;
          # virtualisation.spiceUSBRedirection.enable = true;
        };
      }
