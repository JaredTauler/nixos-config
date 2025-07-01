{ config, pkgs, inputs, ... }:
let

  openrazer-overlay = self: super: {
    openrazer-daemon = super.openrazer-daemon.overrideAttrs (oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.gobject-introspection pkgs.wrapGAppsHook3 pkgs.python3Packages.wrapPython];
        });
  };

  freerdp-overlay = import ../../overlay/freerdp.nix;

in
{
  # nixpkgs.hostPlatform = pkgs.lib.systems.x86_6 4-linux;
  nixpkgs.system = "x86_64-linux";

  nixpkgs.overlays = [
    freerdp-overlay
  ];

  system.stateVersion = "24.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;


  swapDevices = [{
    device = "/swapfile";
    size = 32 * 1024;
  }];



  imports =
    [
      ./hardware.nix
      ./video.nix
      ./vfio.nix

      ../../option/printer/epson-et3750.nix
      ../../option/hyprland.nix

       # ../../option/3dprinter.nix
       #
       inputs.nix-flatpak.nixosModules.nix-flatpak
       inputs.NixVirt.nixosModules.default

    ];

  services.flatpak.enable = true;



  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;
  # services.xserver.desktopManager.xfce.enable = true;
  # services.xserver.windowManager.exwm.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  users.users.jared.extraGroups = [ "docker" "libvirtd" "kvm" "openrazer" "dialout"];



  networking.firewall.enable = false;
  networking.firewall.interfaces."enp4s0".allowedTCPPorts = [
    # Minecraft
    25565
    25566

    # Abiotic Factor
    7777
    27015
  ];

hardware.openrazer.enable = true;
  # services.udev.extraRules = '' SUBSYSTEM=="usb", ATTR{idVendor}=="2dc8", ATTR{idProduct}=="310a", ATTR{manufacturer}=="8BitDo", RUN+="${pkgs.systemd}/bin/systemctl start 8bitdo-ultimate-xinput@2dc8:310a" # This device (2dc8:3016) is "connected" when the above device disconnects SUBSYSTEM=="usb", ATTR{idVendor}=="2dc8", ATTR{idProduct}=="301a", ATTR{manufacturer}=="8BitDo", RUN+="${pkgs.systemd}/bin/systemctl stop 8bitdo-ultimate-xinput@2dc8:310a" '';


  environment.systemPackages = with pkgs; [
    pciutils

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

    freerdp
    inputs.winapps.packages."${pkgs.system}".winapps
    inputs.winapps.packages."${pkgs.system}".winapps-launcher


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

 # TODO fix file picker for vbox
 # export QT_QPA_PLATFORMTHEME=gtk2

  # TODO Does this work???
  # # Udev rules to start or stop systemd service when controller is connected or disconnected
  # services.udev.extraRules = ''
  #   # May vary depending on your controller model, find product id using 'lsusb'
  #   SUBSYSTEM=="usb", ATTR{idVendor}=="2dc8", ATTR{idProduct}=="310a", ATTR{manufacturer}=="8BitDo", RUN+="${pkgs.systemd}/bin/systemctl start 8bitdo-ultimate-xinput@2dc8:310a"
  #   # This device (2dc8:310a) is "connected" when the above device disconnects
  #   SUBSYSTEM=="usb", ATTR{idVendor}=="2dc8", ATTR{idProduct}=="310a", ATTR{manufacturer}=="8BitDo", RUN+="${pkgs.systemd}/bin/systemctl stop 8bitdo-ultimate-xinput@2dc8:310a"
  # '';

  # # Systemd service which starts xboxdrv in xbox360 mode
  # systemd.services."8bitdo-ultimate-xinput@" = {
  #   unitConfig.Description = "8BitDo Ultimate Controller XInput mode xboxdrv daemon";
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.xboxdrv}/bin/xboxdrv --mimic-xpad --silent --type xbox360 --device-by-id %I --force-feedback";
  #   };
  # };







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
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };








boot.supportedFilesystems = [ "ntfs" ];


# NixVirt
virtualisation.libvirt = {
  enable = true;
  swtpm.enable = true;
  verbose = true;


};
users.users.qemu.isSystemUser = true;
users.users.qemu.group = "qemu";
users.groups.qemu = {};
users.users.qemu.extraGroups = [ "render" "video" ];   # /dev/dri/* ACLs
#
virtualisation.libvirt.connections."qemu:///system".domains = [
  {
    definition = inputs.NixVirt.lib.domain.writeXML (inputs.NixVirt.lib.domain.templates.windows {
      name = "RDPWindows";
      uuid = "13f0f0bd-a464-492b-832f-a7b07cd0ee4f";

      memory = { count = 10; unit = "GiB"; };

      storage_vol = {
        pool = "default";                  # You must create this pool
        volume = "win11.qcow2";        # Existing or created separately
      };

       install_vol = "/var/lib/libvirt/images/Win11.iso"; # Replace with your ISO path
       nvram_path = "/var/lib/libvirt/qemu/nvram/win11_VARS.fd";


      virtio_net = true;
      virtio_drive = true;
      install_virtio = true;

      secure = true;

      
    });

    active = true;
    restart = false;

  }
];



# services.ollama = {
#   enable = true;
#   acceleration = "cuda";
# };




  programs.evolution = {
    enable  = true;                       # pulls the wrapped binary
    plugins = [ pkgs.evolution-ews ];     # Exchange Web-Services plug-in
  };

  ## Session plumbing Evolution relies on
  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable               = true;
}
