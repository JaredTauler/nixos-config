{ config, lib, pkgs, ... }:

{
  users.users.jared.extraGroups = [ "openrazer" ];
  hardware.openrazer.enable = true;

}
