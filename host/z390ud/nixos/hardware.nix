# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  # if you are using a Radeon card you can change this to amdgpu or radeon
  boot.blacklistedKernelModules = [ "nvidia" ];

  boot.kernelModules = [ "kvm-intel" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];

  # Set which GPU(s) to use for VFIO
  boot.extraModprobeConfig = "options vfio-pci ids=10de:1e89,10de:10f8,10de:1ad8,10de:1ad9";


  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/cb476d32-de1d-44c9-8b34-ab164fda636c";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/802E-2800";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;


  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Load nvidia driver for Xorg and Wayland

  #imports = [ ];

  #  boot.kernelParams = [ "module_blacklist=i915" ]; # blacklist integrated gpu

  #services.xserver.videoDrivers = ["nvidia"];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  #  hardware.nvidia = { 
  #    nvidiaPersistenced = true;
  #    modesetting.enable = false; 
  #    powerManagement.enable = false; 
  #    powerManagement.finegrained = false; 
  #    forceFullCompositionPipeline = false;
  #    open = true; 
  #    nvidiaSettings = true; 
  #    package = config.boot.kernelPackages.nvidiaPackages.production; 


  #  }; 

  hardware.steam-hardware.enable = true;

  # hardware.opengl.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraConfig = ''
      	load-module module-remap-sink sink_name=remap surround40:FL,FR,SL,SR
    '';
  };



}
