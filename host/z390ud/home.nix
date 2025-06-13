{ inputs
, lib
, config
, pkgs
, nix-colors
, getHomeOption
, ...
}: {
  imports = [
    # nix-colors.homeManagerModules.default
  ] ++ getHomeOption [
    "hyprland.nix"
  ];


  home.packages = with pkgs; [
    emacs30-pgtk

    pandoc # TODO
    texliveFull

    prismlauncher

    jetbrains.webstorm
  ];
  
}
