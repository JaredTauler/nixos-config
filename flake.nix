{
  # TODO how make deez separate file
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixarr.url              = "github:rasmus-kirk/nixarr";
    nix-colors.url          = "github:misterio77/nix-colors";
    nix-colors-adapters.url = "gitlab:vfosnar/nix-colors-adapters";

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    NixVirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprshell = {
      url = "github:H3rmt/hyprswitch?ref=hyprshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";  # or "nixpkgs"
    };


    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";   # track main branch
    };

    # goneovim.url = "path:./goneovim";





    hyprland.url = "github:hyprwm/Hyprland";

    hyprsession.url = "github:joshurtree/hyprsession";

    hyprland-virtual-desktops = {
      url = "github:levnikmyskin/hyprland-virtual-desktops";
      inputs.nixpkgs.follows = "hyprland";
    };
  };

  outputs = { self, ... } @ inputs:
  let
    lib = inputs.nixpkgs.lib;
    collect = import ./lib/collect.nix {inherit lib;};

    hostFiles = builtins.attrNames (builtins.readDir ./host);

    hostAttrs = map
    (
      folder:

      let        
      hostConfig = import (./host + "/${folder}") {
        inherit inputs;
      };
      in
      {
        # Host definition
        name = folder; # Named after folder name
        value = hostConfig.nixpkgs.lib.nixosSystem {
          system = hostConfig.system;
          modules =
            hostConfig.modules ++
            (collect ./module) ++
            (collect ./home-module); 
            specialArgs = {
              inherit inputs folder;
            };
        };
      }
    )
    hostFiles;

    hosts = builtins.listToAttrs hostAttrs;

  in {
    nixosConfigurations = hosts;
  };
}
