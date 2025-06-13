let
  inputs = import ./inputs.nix;

  pkgs = inputs."nixpkgs-unstable";
in
pkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./modules/base.nix
    ./modules/desktop.nix
    ./host/z390ud/hardware.nix
    ./host/z390ud/system.nix
  ];
}
