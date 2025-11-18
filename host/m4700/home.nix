{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "24.05";

  my.emacs.enable = true;

  my.hyprland.enable = true;
  # my.hyprland.sources = [
  #   "/home/jared/nixos-config/host/z390ud/hyprland.conf"
  #   # (toString monitorsFile)
  # ];
}
