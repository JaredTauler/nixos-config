[
  {
    name = "DVI-D-1";
    res = "1920x1080";
    pos = "1600x-1080";
    scale = 1;
    extras = [ "transform,2" ];
  }
  {
    name = "HDMI-A-2";
    res = "2560x1440";
    pos = "0x0";
    scale = 1;
    extras = [ ];
  }
  {
    name = "HDMI-A-1";
    res = "2560x1440@144";
    pos = "2560x0";
    scale = 1;
    extras = [ "bitdepth,10" "vrr,1" "cm,hdr" ];
  }
]


#   mkMonitorLine = m:
#   let
  #     parts = [
    #       m.name
    #       m.res
    #       m.pos
    #       (toString m.scale)
    #     ] ++ m.extras;
    #   in
    #   "monitor = ${lib.concatStringsSep "," parts}";
    # in
    # {
      # # inherit monitors mkMonitorLine;
      #   hyprlandMonitors = map mkMonitorLine;

      # }
