{ config, lib, pkgs, ... }:

{
  nixpkgs.system = "x86_64-linux";


  system.stateVersion = "25.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;


  imports = [
    ./emacs.nix
    ../../option/hyprland.nix

    # TODO 3d printer
    # ../../option/3dprinter.nix


  ];


}
