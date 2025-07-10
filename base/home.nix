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

];

programs.home-manager.enable = true;

programs.git = {
  enable = true;
  userName = "jared";
  userEmail = "jaredt2003@hotmail.com";
};

systemd.user.startServices = "sd-switch";
}
