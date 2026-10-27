{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.my.hyprland;
  # nautilusPortal = pkgs.writeTextFile {
  #   name = "nautilus-xdg-portal";
  #   destination = "/share/xdg-desktop-portal/portals/nautilus.portal";
  #   text = ''
  #     [portal]
  #     DBusName=org.gnome.Nautilus
  #     Interfaces=org.freedesktop.impl.portal.FileChooser
  #   '';
  # };
in {
  options.my.hyprland.enable =
    lib.mkEnableOption "Enable Hyprland system-side integration";

  config = lib.mkIf cfg.enable {
    services.dbus.enable = true;
    programs.dconf.enable = true;

    # This is fine (though user-session vars often matter more than system-wide)
    environment.variables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    services.picom.enable = false;

    # xdg.portal = {
    #   enable = true;

    #   extraPortals = [
    #     pkgs.xdg-desktop-portal-gtk
    #     pkgs.xdg-desktop-portal-hyprland
    #     nautilusPortal
    #   ];

    #   config.common = {
    #     default = ["hyprland" "gtk"];

    #     "org.freedesktop.impl.portal.FileChooser" = ["nautilus"];
    #   };
    # };
    # Force OrcaSlicer to leverage the system portals via environment variables
    # environment.sessionVariables = {
    #   GTK_USE_PORTAL = "1"; #
    # };

    #   environment.systemPackages = with pkgs; [
    #     # qt6.qt6ct
    #     # qt5.qt5ct
    #     libsForQt5.qt5ct
    #     libsForQt5.qtstyleplugin-kvantum
    #   ];

    #   xdg.portal = {
    #     enable = true;
    #     extraPortals = with pkgs; [
    #       xdg-desktop-portal-hyprland
    #       # kdePackages.xdg-desktop-portal-kde
    #       xdg-desktop-portal-gtk
    #     ];
    #     # config.common.default = ["hyprland" "gtk"];
    #     config.common.default = ["hyprland" "gtk"];
    #   };
  };
}
