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
  ];




  home.packages = with pkgs; [
    emacs30-pgtk

    pandoc # TODO
    texliveFull

    prismlauncher

    jetbrains.webstorm



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
}
