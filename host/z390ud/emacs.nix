{ config, lib, pkgs, ... }:

{
   environment.systemPackages = with pkgs; [
     cmake
     make
     editorconfig
     npm
     tidy
     stylelint
     js-beautify
   ];
}
