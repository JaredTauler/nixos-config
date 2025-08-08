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
    ../../option/hyprland.nix
./video.nix

    # TODO 3d printer
    # ../../option/3dprinter.nix


  ];


programs = {
  gamescope = {
    enable = true;
    capSysNice = true;
  };
  steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
};
users.users.jared.extraGroups = ["video" "input"];


services.pipewire = {
	enable = true;
alsa.support32Bit = true;
audio.enable = true;
alsa.enable = true;
pulse.enable = true;
jack.enable = true;

extraConfig.pipewire."context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 1024;
      "default.clock.min-quantum" =1024;
      "default.clock.max-quantum" = 2048;
    };
};
hardware.pulseaudio.enable = false;


boot.kernelParams = [
  "threadirqs"
  "pcie_aspm=off"
];

services.pipewire.wireplumber.enable = true;
security.rtkit.enable = true;

}
