{ inputs
, lib
, config
, pkgs
, ...
}:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm
    xwayland.enable = true;
  };
  services.picom.enable = false;


  environment.systemPackages = with pkgs; [
    font-awesome # For wofi icons
  ];


  fonts.packages = with pkgs; [
    font-awesome_6             # Solid + Regular, 5 MB
    nerd-fonts.symbols-only    # All NF glyphs, 0.9 MB
  ];

  # If you're using Home-Manager, keep this enabled
  # fonts.fontconfig.enable = true;

}
