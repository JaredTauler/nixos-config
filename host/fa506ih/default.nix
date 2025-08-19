{ inputs }:

let
  nixpkgs = inputs."nixpkgs-unstable";
  host = "fa506ih";
in
nixpkgs.lib.nixosSystem {


  specialArgs = {
    inherit inputs host;
  };
  modules = [

    ../../base/config.nix
    ./config.nix
    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    {
	    home-manager.backupFileExtension = "backup";

      home-manager.users.jared = import ./home.nix;
      home-manager.extraSpecialArgs = { inherit inputs; };
    }

  ];


}
