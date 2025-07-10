{ config, lib, pkgs, ... }:

{

  services.emacs = { enable = true; };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
    extraPackages = epkgs:
      with epkgs;
      [

        # texliveFull
      ];
  };

  home.packages = with pkgs; [
    pandoc
    texliveFull

    nixd
    nixfmt

    nodejs_20
    html-tidy

    git
    gcc
    gnumake
    cmake
    libtool

    python3
    direnv
  ];

  # For direnv
  services.lorri.enable = true;

}
