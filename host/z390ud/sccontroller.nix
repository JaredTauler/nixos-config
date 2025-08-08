{ config, lib, pkgs, ... }:

{
  boot.kernelModules = [ "uinput" ];
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input"
  '';

  users.users.jared.extraGroups = [ "input" ];

  environment.systemPackages = [ pkgs.sc-controller ];
  services.dbus.packages = [ pkgs.sc-controller ];

}
