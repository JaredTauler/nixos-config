{ config, lib, pkgs, ... }:

{
  boot.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];

  boot.extraModprobeConfig = ''
    options vfio-pci ids=10de:1f08,10de:10f9
  '';

  boot.kernelParams = [ "intel_iommu=on" ];

}
