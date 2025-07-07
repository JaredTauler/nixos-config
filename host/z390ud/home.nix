{ inputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    # nix-colors.homeManagerModules.default
    #
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ../../base/home.nix
    ../../home-option/hyprland.nix
    ../../home-option/emacs.nix
  ];




  home.packages = with pkgs; [
   prismlauncher

    jetbrains.webstorm
    # (jetbrains.webstorm.override {
    #   vmopts = ''
    #     -Dawt.toolkit.name=WLToolkit
    #     -Dawt.useSystemAAFontSettings=on
    #     -Dswing.aatext=true
    #     -Dsun.java2d.xrender=true
    #   '';
#    })
#

    discord-canary
  ];




  # 2 ) turn Flatpak on for this user
  services.flatpak = {
    enable = true;

    # 3 ) declare the apps you want
    packages = [
      "org.vinegarhq.Sober"     # Roblox client
      # "com.discordapp.Discord"
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
}
