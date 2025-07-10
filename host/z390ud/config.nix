{ config, pkgs, inputs, ... }:
let

  # openrazer-overlay = self: super: {
  #   openrazer-daemon = super.openrazer-daemon.overrideAttrs (oldAttrs: {
  #     nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
  #       pkgs.gobject-introspection
  #       pkgs.wrapGAppsHook3
  #       pkgs.python3Packages.wrapPython
  #     ];
  #   });
  # };

  # freerdp-overlay = import ../../overlay/freerdp.nix;

in {
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

  imports = [
    ./hardware.nix
    ./video.nix
    ./vfio.nix
    ./vm.nix
    ./emacs.nix

    ../../option/openrazer.nix
    ../../option/printer/epson-et3750.nix
    ../../option/hyprland.nix

    # TODO 3d printer
    # ../../option/3dprinter.nix


  ];
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;



  environment.systemPackages = with pkgs; [


    davinci-resolve
  ];

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


  # programs.evolution = {
  #   enable = true; # pulls the wrapped binary
  #   plugins = [ pkgs.evolution-ews ]; # Exchange Web-Services plug-in
  # };

  # ## Session plumbing Evolution relies on
  # services.gnome.gnome-keyring.enable = true;
  # programs.dconf.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot =
    true; # powers up the default Bluetooth controller on boot
  #
  services.blueman.enable = true;
}
