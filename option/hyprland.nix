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

}
