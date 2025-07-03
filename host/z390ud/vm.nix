{ config, lib, pkgs, inputs, ... }:

{
 users.users.jared.extraGroups = [ "libvirtd" "kvm" "video" "render"];





  # NixVirt
          virtualisation.libvirt = {
            enable = true;
            swtpm.enable = true;
            verbose = true;


          };

          # FIXME why does opengl acceleration not work on AMD card
          users.users.qemu.isSystemUser = true;
          users.users.qemu.group = "qemu";
          users.groups.qemu = {};
          users.users.qemu.extraGroups = [ "render" "video" ];   # /dev/dri/* ACLs
            users.users.qemu-libvirtd.extraGroups = [ "render" ];

              ## 2 – tell Mesa where it may write its cache
           #
          virtualisation.libvirt.connections."qemu:///system".domains = [
            {
              definition = inputs.NixVirt.lib.domain.writeXML (
                let
                  base = inputs.NixVirt.lib.domain.templates.windows {
                    name         = "Windows11";
                    uuid         = "13f0f0bd-a464-492b-832f-a7b07cd0ee4f";
                    memory       = { count = 10; unit = "GiB"; };
                    storage_vol  = { pool = "default"; volume = "win11.qcow2"; };
                    install_vol  = "/var/lib/libvirt/images/Win11.iso";
                    nvram_path   = "/var/lib/libvirt/qemu/nvram/win11_VARS.fd";
                    virtio_net   = true;
                    virtio_drive = true;
                    install_virtio = true;
                    secure       = true;

                    active = false;
                  };

                in

                base // {
                  # Merge
                  devices = base.devices // {


                    hostdev = [
                      # RTX 2070
                      {
                        mode    = "subsystem";
                        type    = "pci";

                        managed = true;
                        source = {
                          address = {
                            domain   = 0;
                            bus      = 1;
                            slot     = 0;
                            function = 0;
                          };
                        };

                        address = {
                          type     = "pci";
                          domain   = 0;
                          bus      = 6;
                          slot     = 0;
                          function = 0;
                        };

                      }
                      {
                        mode    = "subsystem";
                        type    = "pci";

                        managed = true;
                        source = {
                          address = {
                            domain   = 0;
                            bus      = 1;
                            slot     = 0;
                            function = 0;
                          };
                        };

                        address = {
                          type     = "pci";
                          domain   = 0;
                          bus      = 6;
                          slot     = 0;
                          function = 0;
                        };

                      }

                    ];
                  };
                }
              );

              active  = false;
              restart = false;
            }
          ];
}
