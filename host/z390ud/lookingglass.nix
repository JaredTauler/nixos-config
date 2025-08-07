{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    looking-glass-client
    obs-studio-plugins.looking-glass-obs

    scream
  ];

  # Create file for scream
  systemd.tmpfiles.rules = [
    "f /dev/shm/scream 0660 jared qemu -"
  ];

  # Scream always hits this multicast IP thingy
  networking.firewall.extraCommands = ''
    iptables -I INPUT -d 239.255.77.77 -p udp --dport 4010 -j ACCEPT
  '';




  # Create and give permissions for this dumbass file looking glass needs.
  boot.kernelModules = [ "kvmfr" ];
  boot.initrd.kernelModules = [ "kvmfr" ];

  boot.extraModulePackages = [ pkgs.linuxPackages.kvmfr ];


  # FIXME 
  boot.extraModprobeConfig = ''
    options kvmfr static_size_mb=256
  '';

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660"
  '';


  users.groups.kvm = { };
  users.users.jared.extraGroups = [ "kvm" ];
  users.users.qemu.extraGroups = [ "kvm" ];

  # FIXME i dont like redclaring all these
  # Make a "list" in libvirtd declaration containing base, and then add kvmfr0 here? that seems genius... if i need to add any more here
  # Add kvmfr0
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    cgroup_device_acl = [
    "/dev/null",
    "/dev/full",
    "/dev/zero",
    "/dev/random",
    "/dev/urandom",
    "/dev/ptmx",
    "/dev/kvm",
    "/dev/kvmfr0",
    "/dev/net/tun",
    "/dev/vfio/vfio"
    ]
  '';


  # use home manager?
  environment.etc."looking-glass-client.ini".text = ''
    [win]
    alerts=no

    [input]
    rawMouse=yes


    [audio]
    micDefault=allow
    micShowIndicator=no
  '';




}
