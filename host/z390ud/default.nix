{ inputs, overlays}:

{
  nixpkgs = inputs."nixpkgs-unstable";

  pkgs = import inputs.nixpkgs-unstable {
    system   = "x86_64-linux";
    inherit overlays;
    config = {
      allowUnfree = true;
    };
  };
  system = "x86_64-linux";

  modules = [
    ../../base/config.nix
    ./config.nix


    inputs.home-manager.nixosModules.home-manager
    {
      nixpkgs.overlays = overlays;
      home-manager.backupFileExtension = "backup";

      home-manager.users.jared = import ./home.nix;
      home-manager.extraSpecialArgs = { inherit inputs; };
    }

  ]; 


}
