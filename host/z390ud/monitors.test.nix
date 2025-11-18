let
  rootFlake = builtins.getFlake "path:/home/jared/nixos-config/";
  # NixVirt = rootFlake.inputs.NixVirt;

  # render = import ./machine/Windows11/xml.nix;
  
in


# (renderVm {
#   inherit NixVirt; name = "test"; }
# )       

