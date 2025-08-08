{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      nvim-treesitter
      lualine-nvim
    ];
  };


  home.packages = with pkgs; [

    neovim-gtk
#    goneovim
  ];

}
