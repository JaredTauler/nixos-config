{ inputs
, lib
, config
, pkgs
, ...
}: {
    programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    # configFile
  };

    services.dbus.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

    # TODO make this
  # ln -s ~/nixos-config/sway/

  environment.systemPackages = with pkgs; [

    # FIXME shit i copied from github
    # alacritty
    # sway
    # dbus-sway-environment
    # configure-gtk
    # wayland
    xdg-utils
    # glib
    # whitesur-icon-theme
    # grim
    # slurp
    wl-clipboard
    # capitaine-cursors
  ]
}