{ config, pkgs, inputs, ... }:
let

  openrazer-overlay = self: super: {
    openrazer-daemon = super.openrazer-daemon.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
        pkgs.gobject-introspection
        pkgs.wrapGAppsHook3
        pkgs.python3Packages.wrapPython
      ];
    });
  };

  freerdp-overlay = import ../../overlay/freerdp.nix;

in {
  # nixpkgs.hostPlatform = pkgs.lib.systems.x86_6 4-linux;
  nixpkgs.system = "x86_64-linux";

  nixpkgs.overlays = [ freerdp-overlay ];

  system.stateVersion = "24.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  swapDevices = [{
    device = "/swapfile";
    size = 32 * 1024;
  }];

  imports = [
    ./hardware.nix
    ./video.nix
    ./vfio.nix
    ./vm.nix
    ./emacs.nix

    ../../option/printer/epson-et3750.nix
    ../../option/hyprland.nix

    # ../../option/3dprinter.nix
    #
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.NixVirt.nixosModules.default

  ];

  services.flatpak.enable = true;

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;


  # services.xserver.desktopManager.xfce.enable = true;
  # services.xserver.windowManager.exwm.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  users.users.jared.extraGroups = [ "docker" "openrazer" "dialout" ];

  # networking.firewall.enable = false;
  # networking.firewall.interfaces."enp4s0".allowedTCPPorts = [
  #   # Minecraft
  #   25565
  #   25566

  #   # Abiotic Factor
  #   7777
  #   27015
  # ];

  hardware.openrazer.enable = true;
  # services.udev.extraRules = '' SUBSYSTEM=="usb", ATTR{idVendor}=="2dc8", ATTR{idProduct}=="310a", ATTR{manufacturer}=="8BitDo", RUN+="${pkgs.systemd}/bin/systemctl start 8bitdo-ultimate-xinput@2dc8:310a" # This device (2dc8:3016) is "connected" when the above device disconnects SUBSYSTEM=="usb", ATTR{idVendor}=="2dc8", ATTR{idProduct}=="301a", ATTR{manufacturer}=="8BitDo", RUN+="${pkgs.systemd}/bin/systemctl stop 8bitdo-ultimate-xinput@2dc8:310a" '';

  environment.systemPackages = with pkgs; [
    pciutils
    direnv

    # xboxdrv
    qemu

    davinci-resolve
    openrazer-daemon
    polychromatic

    OVMF # TODO for win11
    #
    gamescope

    virt-manager

    qdirstat
    gparted

    nixfmt

    freerdp
    inputs.winapps.packages."${pkgs.system}".winapps
    inputs.winapps.packages."${pkgs.system}".winapps-launcher


       #  (android-studio.override {
    #   vmopts = ''
    #          -Dawt.toolkit.name=sun.awt.X11.XToolkit
    #   '';
    # })



  ];
  # nixpkgs.overlays = [
  #   openrazer-overlay
  # ];

  # users.extraGroups.vboxusers.members = [ "jared" ];
  # # TODO

  #  virtualisation.virtualbox.host.enable = true;
  #  virtualisation.virtualbox.host.enableExtensionPack = true;
  #  virtualisation.virtualbox.guest.enable = true;
  #  virtualisation.virtualbox.guest.dragAndDrop = true;

  # virtualisation.libvirt.enable = true;
  # programs.virt-manager.enable = true;
  # boot.extraModprobeConfig = ''
  #   Options kvm_intel nested=1
  #   options kvm_intel emulate_invalid_guest_state=0
  #   options kvm ignore_msrs=1
  # '';
  # #users.users.jared.extraGroups = [ "libvirtd" ];
  # #virtualisation.qemu.host.enable = true;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers =
        null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin =
        "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];

  # services.ollama = {
  #   enable = true;
  #   acceleration = "cuda";
  # };

  programs.evolution = {
    enable = true; # pulls the wrapped binary
    plugins = [ pkgs.evolution-ews ]; # Exchange Web-Services plug-in
  };

  ## Session plumbing Evolution relies on
  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot =
    true; # powers up the default Bluetooth controller on boot
  #
  services.blueman.enable = true;
}
