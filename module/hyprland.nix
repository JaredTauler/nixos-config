{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.my.hyprland;
in
{
  options.my.hyprland.enable =
    lib.mkEnableOption "Enable Hyprland system-side integration";

    config = lib.mkIf cfg.enable {
      services.dbus.enable = true;
      programs.dconf.enable = true;  

      environment.variables = {
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
      };




      programs.hyprland = {
        # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        enable = true;
        withUWSM = true;
        # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm
        xwayland.enable = true;
      };
      # Something really bad happens if this is enabled with home-manager hyprland
      services.picom.enable = false;
    };
}
