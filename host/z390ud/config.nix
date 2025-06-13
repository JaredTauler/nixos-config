{ config, pkgs, getOption, NixVirt, ... }:
let

  openrazer-overlay = self: super: {
    openrazer-daemon = super.openrazer-daemon.overrideAttrs (oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.gobject-introspection pkgs.wrapGAppsHook3 pkgs.python3Packages.wrapPython];
        });
  };

in
{
  # nixpkgs.hostPlatform = pkgs.lib.systems.x86_6 4-linux;
  nixpkgs.system = "x86_64-linux";
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
      NixVirt.nixosModules.default
    ] ++ getOption [
      "printer/epson-et3750.nix"
      "hyprland.nix"
      "kodi/.nix"
      "winapps.nix"
      "3dprinter.nix"
    ];


  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;
  # services.xserver.windowManager.exwm.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  users.users.jared.extraGroups = [ "docker" "libvirtd" "openrazer" "dialout"];



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

    xboxdrv
    qemu

    davinci-resolve
    openrazer-daemon
    polychromatic

    OVMF # TODO for win11


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







  virtualisation.libvirt.enable = true;
  programs.virt-manager.enable = true;
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';
  #users.users.jared.extraGroups = [ "libvirtd" ];  
  #virtualisation.qemu.host.enable = true;


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



  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];





  nixarr = {
    enable = true;

    # vpn.enable = true;
    vpn.wgConf = "/home/jared/nixos-config/secret/denver.conf"; # FIXME

    # vpn.vpnTestService.enable = true;
    # vpn.vpnTestService.port = 1000;

    sonarr = {
      # package = unstable.sonarr;
      enable = true;
      # vpn.enable = true;
    };




    jellyfin = {
      enable = true;
      # stateDir = "/home/jared/jellyfinstatedir";
    };

    transmission = {
      enable = true;
      # vpn.enable = true;
    };
  };

  services.jellyseerr = {
    enable = true;
    port = 5055;
    openFirewall = true; # FIXME not working when firewall not open
  };

  # FIXME
  # sudo chown -R radarr /data/media/torrents/radarr/
  nixarr.radarr = {
    # package = unstable.sonarr;
    enable = true;
    # vpn.enable = true;
  };


boot.supportedFilesystems = [ "ntfs" ];

  # Useless with current hardware

  # services.ollama = {
  #   enable = true;
  #   acceleration = "rocm";
  #   environmentVariables = {
  #     HCC_AMDGPU_TARGET = "gfx803"; # used to be necessary, but doesn't seem to anymore
  #   };
  #   rocmOverrideGfx = "8.0.3";
  # };

virtualisation.libvirtd = {
  enable = true;               # you probably have this already
  qemu.swtpm.enable = true;    # ← **THIS is the missing bit**
  # (optional, but useful)
  qemu.ovmf.enable = true;     # UEFI firmware, Secure Boot, etc.
};
virtualisation.libvirt.swtpm.enable = true; # TPM shit
virtualisation.libvirt.connections."qemu:///system".domains = [
  {
    definition = NixVirt.lib.domain.writeXML (NixVirt.lib.domain.templates.windows {
      name = "Windows11";
      uuid = "12345678-1234-1234-1234-123456789abc"; # generate with `uuidgen` TODO

      memory = { count = 10; unit = "GiB"; };

      storage_vol = {
        pool = "default";                  # You must create this pool
        volume = "windows11.qcow2";        # Existing or created separately
      };

      # install_vol = /var/lib/libvirt/images/Win11.iso; # Replace with your ISO path

      nvram_path = /var/lib/libvirt/images/windows11.nvram;

      virtio_net = true;
      virtio_drive = true;
      install_virtio = true;
    });

    active = false;
    # restart = false;

  }
];



# services.ollama = {
#   enable = true;
#   acceleration = "cuda";
# };


}
