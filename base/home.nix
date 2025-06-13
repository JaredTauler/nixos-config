# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, lib
, config
, pkgs
, ...
}: {  

  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ./de.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "jared";
    homeDirectory = "/home/jared";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [

    nixpkgs-fmt # For formatting nix files

    # VScode
    (
      vscode-with-extensions.override {
        vscode = vscodium;

        # Extensions
        vscodeExtensions = with vscode-extensions; [
          ms-python.python

          #bbenoist.nix
          vscode-extensions.jnoortheen.nix-ide
          #vscode-extensions.kamadorueda.alejandra

        ];
      }
    )

    kitty
    floorp
    # flameshot

    libreoffice

    # TODO put this somewhere else
    jetbrains.pycharm-professional
    jetbrains.idea-ultimate
    android-studio    
    #jetbrains.jdk
    #libglvnd



    steam

    # TODO dolphin multiplayer flake?
    # dolphin-emulator
    # bridge-utils # For dolphin

    # TODO minecraft flake?
    #adoptopenjdk-jre-hotspot-bin-8
    #prismlauncher

    vivaldi
    firefox
    chromium

    obs-studio
    gimp
    vlc

    discord
    telegram-desktop
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "jared";
    userEmail = "jaredt2003@hotmail.com";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
