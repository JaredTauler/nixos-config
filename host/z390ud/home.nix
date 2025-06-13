{ inputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    # nix-colors.homeManagerModules.default
    ../../base/home.nix
    ../../home-option/hyprland.nix
  ];


  home.packages = with pkgs; [
    emacs30-pgtk

    pandoc # TODO
    texliveFull

    prismlauncher

    jetbrains.webstorm
  ];
  
}
