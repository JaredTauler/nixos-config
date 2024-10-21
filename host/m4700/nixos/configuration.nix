{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../option/printer/epson-et3750.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "m4700"; 
  networking.networkmanager.enable = true;



  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  system.stateVersion = "24.05";
}
