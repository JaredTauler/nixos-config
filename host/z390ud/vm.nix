{ pkgs, inputs, ... }:
{
  imports = [
    inputs.NixVirt.nixosModules.default
    # ./vm/machine/Windows11

  ];

  environment.systemPackages = with pkgs; [
    qemu
    OVMF # TODO for win11
    virt-manager
  ];


  users.users.jared.extraGroups = [ "libvirtd" "kvm" "video" "render" ];

  # NixVirt
  virtualisation.libvirt = {
    enable = true;
    swtpm.enable = true;
    verbose = true;

  };

  virtualisation.libvirtd.enable = true;

  users.users.qemu.isSystemUser = true;
  users.users.qemu.group = "qemu";
  users.groups.qemu = { };
  users.users.qemu.extraGroups = [ "render" "video" ]; # /dev/dri/* ACLs
  users.users.qemu-libvirtd.extraGroups = [ "render" ];


  # virtualisation.libvirt.connections."qemu:///system".domains = [{
  #   definition =

  #     active = false;
  #     restart = false;
  # }];
}
