{ inputs , lib , config , pkgs , ... }: {


  imports = [

  ];

  nixpkgs = {

    overlays = [

    ];

    config = {

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

  home.packages = with pkgs; [
    libreoffice

    steam
    gamescope

    # TODO dolphin multiplayer flake?
    # dolphin-emulator
    # bridge-utils # For dolphin

    # TODO minecraft flake?
    #adoptopenjdk-jre-hotspot-bin-8
    #prismlauncher

    vivaldi
    chromium

    obs-studio
    gimp
    vlc

    discord
    telegram-desktop


    qdirstat
    gparted


    gnome-icon-theme
    gnome-themes-extra
    hicolor-icon-theme
    adwaita-icon-theme
    papirus-icon-theme


    nerd-fonts.fira-code
    nerd-fonts.noto
    nerd-fonts.symbols-only




  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "jared";
    userEmail = "jaredt2003@hotmail.com";
  };

  systemd.user.startServices = "sd-switch";

  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";     # string must match folder inside /share/themes
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Many modern GTK-4 apps look at this key first:
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };


  fonts = {
    fontconfig.enable = true;
  };

  programs.bash = {
    enable = true;

  };


  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    # TODO make quiet but not silent
    silent = true;
  };

  home.keyboard = {
    layout = "us";
    options = [ "caps:escape" ];
  };



}
