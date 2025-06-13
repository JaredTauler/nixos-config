{
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixarr.url = "github:rasmus-kirk/nixarr"; # Piracy stuff TODO setup
    nix-colors.url = "github:misterio77/nix-colors"; # Universal color tracking thing
    nix-colors-adapters.url = "gitlab:vfosnar/nix-colors-adapters";

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    NixVirt =
  {
    url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , nixarr
    , nix-colors
    , nix-colors-adapters
    , ...
    } @ inputs:
    let
      inherit (self) outputs;



      # Function for options folders
      getOption = fileNames:
        let
          normalize = names: if builtins.isList names then names else [ names ];
        in
        map (fileName: "${./option}/${fileName}") (normalize fileNames);

      getHomeOption = fileNames:
        let
          normalize = names: if builtins.isList names then names else [ names ];
        in
        map (fileName: "${./home-option}/${fileName}") (normalize fileNames);
      


          # Overlay that makes pkgs.unstable available
    unstableOverlay = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit (prev) system config overlays;
      };
    };

      # Generate Host, takes a folder 
      generateHostConfig = host: nixpkgs.lib.nixosSystem {

        specialArgs = {
          inherit inputs outputs getOption host;
          winapps = inputs.winapps;
          NixVirt = inputs.NixVirt;
                 };

                 modules = [
          # 1. add the overlay so every module sees pkgs.unstable
          ({ ... }: { nixpkgs.overlays = [ unstableOverlay ]; })

          # 2. your normal stack
          inputs.nixarr.nixosModules.default
          ./base/config.nix
          (import ./host/${host}/config.nix)
        ];
      };

    in
    {
      # Set host to list of generated hosts
      nixosConfigurations = builtins.listToAttrs (map
        (
          host: {
            name = host;
            value = generateHostConfig host;
          }
        )
        (
          builtins.attrNames (builtins.readDir ./host)
        )
      );
      #     nixosConfigurations =
      # builtins.listToAttrs (map
      #   (h: { name = h; value = generateHostConfig h; })
      #   (builtins.attrNames (builtins.readDir ./host)));


      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        # FIXME replace with your username@hostname
        "jared@m4700" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./base/home.nix ];
        };

        "jared@z390ud" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              nix-colors
              nix-colors-adapters
              getHomeOption;
          };
          modules = [
            ./base/home.nix
            ./host/z390ud/home.nix

            # TODO p sure theres a nicer way to import
            inputs.nix-colors.homeManagerModules.default
            inputs.nix-colors-adapters.homeManagerModules.default
          ];


        };
      };
    };
}
