{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # The "nix hooks" did not work for the intel GPU specifically.
  # https://discourse.nixos.org/t/nvidia-gpu-and-i915-kernel-module/21307/3

  boot.kernelParams = [
    "module_blacklist=i915"

    "intel_iommu=on"
    "iommu=pt"
    "vfio-pci.ids=1002:665f"
  ];


  boot.kernelModules = [ "kvm-intel" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];

  # Set which GPU(s) to use for VFIO
  # boot.extraModprobeConfig = "options vfio-pci ids=1002:665f";


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


  # services.xserver.videoDrivers = [ "amdgpu" ];







}
