# { config, pkgs, ... }: {
#   hardware.openrazer.enable = true
#   environment.systemPackages = with pkgs; [
#       openrazer-daemon
#    ];

# }
{ config, pkgs, ... }: {
  hardware.openrazer.enable = true;

  environment.systemPackages = with pkgs; [
    openrazer-daemon    
    polychromatic # Front end
  ];
  users.users.jared = { extraGroups = [ "openrazer" ]; };
}
