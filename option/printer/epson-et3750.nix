{ config, pkgs, ... }: {
  # TODO i forget what i actually need here


  # Printing + Scanning
  hardware.sane.enable = true;
  hardware.sane.drivers.scanSnap.enable = true;

  # For Epson ET 3750 (Kitchen) compatability
  hardware.sane.extraBackends = [
    (
      pkgs.epsonscan2.override { withNonFreePlugins = true; }
    )
    pkgs.utsushi
  ];

  # hardware.sane.extraBackends = [ pkgs.utsushi ];
  services.udev.packages = [ pkgs.utsushi ];


  services.printing = {
    enable = true;
    drivers = [
      # pkgs.epson-201401w 
      # pkgs.gutenprint
      # pkgs.epson-workforce-635-nx625-series
      pkgs.epson-escpr2
    ];
  };
  # services.printing.drivers = [ pkgs.gutenprint ];

  services.printing.browsing = true;
  services.printing.browsedConf = ''
    BrowseDNSSDSubTypes _cups,_print
    BrowseLocalProtocols all
    BrowseRemoteProtocols all
    CreateIPPPrinterQueues All

    BrowseProtocols all
  '';
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

}
