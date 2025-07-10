{ nixpkgs, host, inputs }:

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

      home-manager.users.jared = import [
        ../../base/home.nix
        ./home.nix
      ];
      home-manager.extraSpecialArgs = { inherit inputs; };
    }

  ];


}
