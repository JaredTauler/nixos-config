{ inputs
, lib
, config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    gnomeExtensions.unite
    gnomeExtensions.forge
    gnomeExtensions.space-bar
    gnomeExtensions.compiz-alike-magic-lamp-effect # looks cool
    gnomeExtensions.just-perfection

    gnomeExtensions.sleep-through-notifications # without, notifications will wake computer at night
  ];

}
