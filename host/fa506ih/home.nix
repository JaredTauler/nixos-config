{ inputs, config, lib, pkgs, ... }:

{
  home.stateVersion = "25.05";

  imports = [
    # nix-colors.homeManagerModules.default
    #
	  ../../base/home.nix
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ../../home-option/hyprland.nix 

    ../../home-option/emacs
  ];

  my.hyprland.sources = lib.mkAfter [
    "~/nixos-config/host/fa506ih/hyprland.conf"
  ];


  home.packages = with pkgs; [
    prismlauncher

    jetbrains.webstorm
  ];


}
