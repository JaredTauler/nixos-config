{ config, lib, pkgs, inputs, ... }:
let
  # https://looking-glass.io/docs/B7/install_libvirt/#libvirt-determining-memory
  ivshmem-size = 128;
in

{
    imports = [
    inputs.NixVirt.nixosModules.default

  ];

}
