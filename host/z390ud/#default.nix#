{ inputs, }:

{
  nixpkgs = inputs."nixpkgs-unstable";

  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  modules = [
    ../../base/config.nix
    ./config.nix


    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.backupFileExtension = "backup";

      home-manager.users.jared = import ./home.nix;
      home-manager.extraSpecialArgs = { inherit inputs; };
    }

  ]; 


}
