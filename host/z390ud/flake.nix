{
  inputs = import ../../default.nix {
    overrides = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # 👈 override for this host
    };
  };


  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.z390ud = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ../modules/base.nix
        ../modules/desktop.nix
        ./hardware.nix
        ./system.nix
      ];
    };
  };
}
