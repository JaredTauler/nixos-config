{ inputs, config, lib, pkgs, ... }:

{
  home.stateVersion = "25.05";

  imports = [
    # nix-colors.homeManagerModules.default
    #
	  ../../base/home.nix
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    (import ../../home-option/hyprland.nix {
      # FIXME absolute brainrot
      sources = [ "~/nixos-config/host/fa506ih/hyprland.conf" ];
    })
    
    ../../home-option/emacs
  ];




  home.packages = with pkgs; [
    prismlauncher

    jetbrains.webstorm
  ];


}
