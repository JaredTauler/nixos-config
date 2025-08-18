{ config, lib, pkgs, ... }:

{
  nixpkgs.system = "x86_64-linux";


  system.stateVersion = "25.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;


  imports = [
    ../../option/hyprland.nix
    ./video.nix

    # TODO 3d printer
    # ../../option/3dprinter.nix


  ];


  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
  users.users.jared.extraGroups = ["video" "input"];


  services.pipewire = {
	  enable = true;
    alsa.support32Bit = true;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig.pipewire."context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 1024;
      "default.clock.min-quantum" =1024;
      "default.clock.max-quantum" = 2048;
    };
  };
  hardware.pulseaudio.enable = false;
  services.ofono.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
      Enable = "Source,Sink,Media,Socket";
    };
  };

  # PipeWire/WirePlumber Bluetooth tuning
  services.pipewire.wireplumber.extraConfig = {
    # Global bluetooth policy + codec tuning
    "bluetooth.lua.d/51-bt-tuning.lua".text = ''
      bluez_monitor = bluez_monitor or {}
      bluez_monitor.properties = {
      -- Keep audio at 48k stereo; avoid weird resampling
      ["bluez5.default.rate"] = 48000,
      ["bluez5.default.channels"] = 2,

      -- A2DP codecs
      ["bluez5.enable-aac"] = true,
      ["bluez5.aac.bitratemode"] = 1,   -- 0=CBR, 1=VBR
      ["bluez5.aac.vbrquality"] = 5,    -- 0..5 (max)

      ["bluez5.enable-sbc-xq"] = true,
      ["bluez5.sbc-xq.bitpool"] = 53,   -- max (~512 kbps)

      -- If you don't want headset mic to ever take over:
      ["bluez5.hfphsp-backend"] = "none",
      }

      bluez_monitor.rules = bluez_monitor.rules or {}
      table.insert(bluez_monitor.rules, {
      matches = { { { "device.name", "matches", "bluez_card.*" } }, },
      apply_properties = {
      -- Default to high-quality music; don't auto flip to HFP
      ["bluez5.default.profile"] = "a2dp-sink",
      ["bluez5.auto-switch-profile"] = false,
      }
      })
    '';
  };

  # Optional: keep PipeWire at 48k only (helps avoid thin resample artifacts)
  services.pipewire.extraConfig.pipewire."context.properties" = {
    "default.clock.allowed-rates" = [ 48000 ];
  };
  boot.kernelParams = [
    "threadirqs"
    "pcie_aspm=off"
  ];

  services.pipewire.wireplumber.enable = true;

  # hardware.bluetooth = {
    #   enable = true;
    #   settings = {
      #     General = {
        #       Experimental = true;
        #       Enable = "Source,Sink,Media,Socket";
        #     };
        #   };
        # };




        security.rtkit.enable = true;
        environment.systemPackages = with pkgs; [

        ];
        services.hardware.openrgb.enable = true;
}
