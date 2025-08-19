{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.my.desktop.hyprland;
in
{
  options.my.desktop.hyprland.enable =
    lib.mkEnableOption "Enable Hyprland system-side integration";

    config = lib.mkIf cfg.enable {  
    programs.hyprland = {
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      enable = true;
      withUWSM = true;
      # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm
      xwayland.enable = true;
    };
    # Something really bad happens if this is enabled with home-manager hyprland
    services.picom.enable = false;
    };
}
