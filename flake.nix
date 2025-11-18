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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";  # or "nixpkgs"
    };


    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";   # track main branch
    };






    hyprland.url = "github:hyprwm/Hyprland";

    hyprsession.url = "github:joshurtree/hyprsession";

    hyprland-virtual-desktops = {
      url = "github:levnikmyskin/hyprland-virtual-desktops";
      # inputs.nixpkgs.follows = "hyprland"; # follows hyprland
    };

    hyprshell = {
      url = "github:H3rmt/hyprswitch?ref=hyprshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };




  outputs = { self, ... } @ inputs:    
  let
    # overlays = [
    #   (final: prev: {
    #     hyprland  = inputs.hyprland.packages.${final.system}.hyprland;
    #     hyprshell = final.callPackage "${inputs.hyprshell}/." { };
    #   })
    #   inputs.rust-overlay.overlays.default
   # ];
    

    collect = import ./lib/collect.nix {lib = inputs.nixpkgs.lib;};


    hostFiles = builtins.attrNames (builtins.readDir ./host);

    hostAttrs = map
    (
      fname:

      let        
      hostConfig = import (./host + "/${fname}") {
        inherit inputs ;
      };
      in
      {
        # Host definition
        name = fname; # Named after folder name

        # Actually set nixosSystem, meaning host/$hostname/default.nix should be a module
        value = hostConfig.nixpkgs.lib.nixosSystem {
          inherit (hostConfig) system pkgs;
          # system = hostConfig.system;
          modules =
            hostConfig.modules ++
            (collect {
              path = ./module;
              handle = file: import file;
            }) ++
            # FIXME yucky
            # Should probably just tack modules in each host
            [
              {
                home-manager.users.jared.imports = collect {
                  path = ./home-module;
                  handle = file: import file;
                };
              }
            ];

            specialArgs = {
              inherit inputs fname ;
              host = fname; 
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
