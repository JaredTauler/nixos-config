{
  description = "Neovim with Goneovim GUI flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Optional: neovim-nightly
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, neovim-nightly }: flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};

    goneovim = pkgs.stdenv.mkDerivation {
      pname = "goneovim";
      version = "latest";
      src = pkgs.fetchgit {
        url           = "https://github.com/akiyosi/goneovim.git";
        rev = "master";
        sha256 = "0vagzqb7fmnj9iypybx819cqablzr5hpx7w1z99nsmph2x5z63d9";
        leaveDotGit = true;
        deepClone = true;
      };
      nativeBuildInputs = [
        pkgs.git
        pkgs.go
        pkgs.qt5.qtbase
        pkgs.qt5.qttools
        pkgs.qt5.wrapQtAppsHook
      ];
      buildInputs = [ pkgs.neovim ];

preBuild = ''
  git init
  git add -A
  git commit -m init --author="nix <nix@localhost>" \
                     --date="1970-01-01T00:00:00Z"
'';
buildPhase = "make app";
      # Optional: implement buildPhase/installPhase if needed
      installPhase = ''
        mkdir -p $out/bin
        cp -v goneovim $out/bin/
      '';
    };

    neovimPkg =
      if builtins.hasAttr system neovim-nightly.packages then
      neovim-nightly.packages.${system}.neovim
      else
      pkgs.neovim;
  in
  {
    packages = {
      default = neovimPkg;
      goneovim = goneovim;
    };

    apps.${system}.default = {
      type = "app";
      program = "${neovimPkg}/bin/nvim";
    };

    apps.${system}.goneovim = {
      type = "app";
      program = "${goneovim}/bin/goneovim";
    };
  }
  );
}
