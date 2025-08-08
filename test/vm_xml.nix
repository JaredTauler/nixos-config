{ lib, NixVirt, pkgs }:
 # TODO test XML... next time it gets fucked up
let
  domains = [
  ];

  renderXMLs = map (file:
    import file {
      inherit lib NixVirt;
    }
  ) domains;
in
pkgs.writeShellScriptBin "print-vms" ''
  echo ${lib.concatStringsSep "\n\n" renderXMLs}
''
