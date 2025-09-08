# { inputs }: final: prev:
# let
#   pkgsWithRust = import inputs.nixpkgs {
#     system   = prev.system;
#     overlays = [ inputs.rust-overlay.overlays.default ];
#   };

#   rustNightly = pkgsWithRust.rust-bin.nightly.latest.default;
# in {
#   hyprshell = inputs.hyprshell.packages.${prev.system}.hyprshell.override {
#     rustPlatform = pkgsWithRust.makeRustPlatform {
#       cargo = rustNightly;
#       rustc = rustNightly;
#     };
#   };
# }

final: prev: {
  hyprshell = inputs.hyprshell.packages.${final.system}.hyprshell

    .override {
    rustPlatform = final.makeRustPlatform {
      cargo = final.rust-bin.nightly.latest.default;
      rustc = final.rust-bin.nightly.latest.default;
    };
  };
}
