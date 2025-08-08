# { nixpkgs ? import <nixpkgs> {}, NixVirt ? import <inputs.NixVirt> {} }:

# let
  #   renderVm = import ./machine/Windows11/xml.nix;
  # in
  # (renderVm {
    #   inherit NixVirt; name = "test"; }
    # )


# nix build -f test_vm_xml.nix -o /tmp/xml.xml && cat /tmp/xml.xml 


    let
      rootFlake = builtins.getFlake "path:/home/jared/nixos-config/";
      NixVirt = rootFlake.inputs.NixVirt;

      renderVm = import ./machine/Windows11/xml.nix;
    in
    (renderVm {
      inherit NixVirt; name = "test"; }
    )       

