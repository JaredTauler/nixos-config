{ config, pkgs, host, ... }:

{
  # Set host name (got-en from host folder name)
  networking.hostName = host;



  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true; # FIXME why doesnt this work here



  # Users
  users.users.jared = {
    isNormalUser = true;
    description = "Jared Tauler";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  users.users.jordan = {
    isNormalUser = true;
    description = "Jordan Pothitos";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # TODO figure out how to make fancy command to rebuild
  # programs.bash.shellAliases = {
  #   l = "echo ${toString config.system.}";
  #   ll = "ls -l";
  #   ls = "ls --color=tty";
  # };

  # Locale and timezone
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };



}
