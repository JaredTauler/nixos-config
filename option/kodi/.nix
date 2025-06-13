{ config, pkgs, unstable, ... }:

{
#   environment.systemPackages = with pkgs; [
#   (retroarch.override {
#     cores = with libretro; [
#       genesis-plus-gx
#       snes9x
#       beetle-psx-hw
#       dolphin
#     ];
#   })
# ];
  # services.xserver.desktopManager.kodi.enable = true;


  environment.systemPackages = with pkgs; [
    # kodi-retroarch-advanced-launchers
    # retroarch
    # libretro.dolphin

    (retroarch.override {
      cores = with libretro; [
        genesis-plus-gx
        snes9x
        beetle-psx-hw        
        pcsx2
        dolphin
      ];
    })


    (kodi.withPackages (kodiPkgs: with kodiPkgs; [
      jellyfin

      #steam-library
      # steam-launcher
      libretro
      joystick

    ]))
  ];
  
}
