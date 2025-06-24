{ inputs }:

let
  nixpkgs = inputs."nixpkgs-unstable";
  host = "z390ud";
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

    specialArgs = {
    inherit inputs host;
  };
  modules = [
    ../../base/config.nix
      ./config.nix


    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.users.jared = import ./home.nix;
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
    # Add more modules if needed
    # ./hardware.nix
    # ./system.nix
  ];

  
}
