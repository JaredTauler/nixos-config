{ inputs}:

{
  nixpkgs = inputs."nixpkgs-unstable";
  host = "z390ud";

  # specialArgs = {
  #   inherit inputs host;
  # };
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
