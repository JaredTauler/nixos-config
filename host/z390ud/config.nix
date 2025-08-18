{ config, pkgs, inputs, ... }:
let


in {
  nixpkgs.system = "x86_64-linux";


  system.stateVersion = "24.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  swapDevices = [{
    device = "/swapfile";
    size = 32 * 1024;
  }];

  imports = [
    ./hardware.nix
    ./video.nix
    ./vfio.nix
    ./vm.nix
    ./emacs.nix
    ./lookingglass.nix
    ./sccontroller.nix

    ../../option/openrazer.nix
    ../../option/printer/epson-et3750.nix
    ../../option/hyprland.nix

    # TODO 3d printer
    # ../../option/3dprinter.nix


  ];
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;



  environment.systemPackages = with pkgs; [
    cpuset
    davinci-resolve
  ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers =
        null; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin =
          "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];



  systemd.targets = {
    sleep.enable       = false;   # generic sleep target
    suspend.enable     = false;   # S3 “Suspend”
    hibernate.enable   = false;   # S4 “Hibernate”
    hybridSleep.enable = false;   # Suspend‑then‑Hibernate
  };


}
