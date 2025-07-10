{ config, lib, pkgs, ... }:

{
   nixpkgs.overlays = [
    (self: super: {
      printrun = super.printrun.overridePythonAttrs (old: {
        propagatedBuildInputs =
          (old.propagatedBuildInputs or [])
          ++ [
            self.python3Packages.platformdirs
          ];
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    printrun          # wrapped “pronterface”, now works
    slic3r
  ];

  # For serial
  users.users.jared.extraGroups = [ "dialout" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", GROUP="dialout", MODE="0660"
  '';
}
