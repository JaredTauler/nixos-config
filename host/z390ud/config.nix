{
  config,
  pkgs,
  inputs,
  ...
}: let
in {
  system.stateVersion = "24.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 32 * 1024;
    }
  ];

  imports = [
    ./hardware.nix
    ./video.nix
    ./vfio.nix
    ./vm.nix
    ./lookingglass.nix

    ../../option/openrazer.nix
    ../../option/printer/epson-et3750.nix
    # TODO 3d printer
    # ../../option/3dprinter.nix
  ];

  systemd.slices."user.slice" = {
    sliceConfig = {
      CPUWeight = 900;
      IOWeight = 900;
    };
  };

  # boot.kernelPackages = pkgs.linuxPackages_zen;

  my.hyprland.enable = true;
  vfio.enable = true;

  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    cpuset
    # davinci-resolve

    nexusmods-app-unfree

    thunderbird

    xenia-canary

    cacert
  ];

  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      AllowUsers =
        null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  boot.supportedFilesystems = ["ntfs"];

  # FIXME actually solve, was going to sleep as i was using PC clicking on shit
  systemd.targets = {
    sleep.enable = false; # generic sleep target
    suspend.enable = false; # S3 “Suspend”
    hibernate.enable = false; # S4 “Hibernate”
    hybridSleep.enable = false; # Suspend‑then‑Hibernate
  };

  programs.adb.enable = true;
  users.users.jared.extraGroups = ["adbusers" "plugdev" "kvm" "libvirtd" "docker" "i2c"];

  # For pixel
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="adbusers"
  '';

  virtualisation.docker.enable = true;
  # users.users.jared.extraGroups = [ "docker" ];
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  security.rtkit.enable = true;

  # Use PipeWire (with Pulse/JACK shims); disable the old Pulse daemon.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # Sane, stable buffering @ 48 kHz
    extraConfig.pipewire."context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 512;
      "default.clock.min-quantum" = 256;
      "default.clock.max-quantum" = 1024;
    };
  };

  hardware.pulseaudio.enable = false;

  hardware.i2c.enable = true;
  # users.users.jared.extraGroups = [ "i2c" ];
}
