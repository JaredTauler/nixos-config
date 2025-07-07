{ config, lib, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30.pgtk;
    extraPackages = epkgs: with epkgs; [
      pandoc
      texliveFull


    ];
  };

}
