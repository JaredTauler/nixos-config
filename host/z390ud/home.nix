{ inputs
, lib
, config
, pkgs
, ...
}:
let
  
in
{
  home.stateVersion = "24.05";

  imports = [
    # nix-colors.homeManagerModules.default
    #
    inputs.nix-flatpak.homeManagerModules.nix-flatpak

    ../../base/home.nix


  ];

  # my.hyprland.sources = lib.mkAfter [
    #   "~/nixos-config/host/fa506ih/hyprland.conf"
  # ];

    my.emacs.enable = true;

    my.hyprland.enable = true;
    my.hyprland.sources = [
      "/home/jared/nixos-config/host/z390ud/hyprland.conf"
      # (toString monitorsFile)
    ];


    # my.hyprland.sources = config.my.hyprland.sources ++ [
      #     "~/nixos-config/host/z390ud/hyprland.conf"
      #   ];



      home.packages = with pkgs; [
        # goneovimPkg
        prismlauncher
        google-chrome

        jetbrains.webstorm
        jetbrains.pycharm-professional

        onlyoffice-bin_latest

        # discord-canary
        flatpak

        blender
        godotPackages_4_5.godot
        
        usbutils
        cowsay

      ];
      # 2 ) turn Flatpak on for this user
      services.flatpak = {
        enable = true;

        # 3 ) declare the apps you want
        packages = [
          "org.vinegarhq.Sober"     # Roblox client
          "com.discordapp.Discord"
          # "org.mozilla.Thunderbird"
        ];

        # optional: keep them fresh without manual `flatpak update`
        update = {
          onActivation = true;      # update every `home-manager switch`
          auto.enable  = true;      # plus a weekly timer
        };
      };

      services.flatpak.overrides."org.vinegarhq.Sober" = {
        # 1) Disable Wayland, enable X11
        # Context = {
          #   wayland = false;
          #   x11     = true;
          # };

          # 2) Environment tweaks
          Environment = {
            SOBER_RENDERER   = "opengl";
            FLATPAK_MAX_MEMORY = "4G";          # raise if you still see OOM crashes
            LC_ALL            = "en_US.UTF-8";  # avoids random locale-related exits
          };
      };













      # programs.nyxt = {
        #   enable = true;
        # };
}
