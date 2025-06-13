# Hosts get the whole `inputs` attr-set from the root flake and
# decide locally which channel / system they want.

{ inputs }:

let
  # For this machine we want nixpkgs-unstable
  pkgs = inputs."nixpkgs-unstable";
in
pkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = [
    ../modules/base.nix
    ../modules/desktop.nix
    ./hardware.nix
    ./system.nix
  ];
}
