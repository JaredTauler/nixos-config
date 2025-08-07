{NixVirt, name }:

let
  ivshmem-size = 256;

  base = NixVirt.lib.domain.templates.windows {
    name = name;
    uuid = "13f0f0bd-a464-492b-832f-a7b07cd0ee4f";
    memory = {
      count = 16;
      unit = "GiB";
    };
    storage_vol = {
      pool = "default";
      volume = "win11.qcow2";
    };
    install_vol = "/var/lib/libvirt/images/Win11.iso";

    # Fuck with this file to disable/enable secure boot
    nvram_path = "/var/lib/libvirt/qemu/nvram/win11_VARS.fd";
    virtio_net = true; # makes faster
    virtio_drive = true; # makes faster
    install_virtio = true; # makes things work between host and client

    secure = true; # require swtpm

    active = false;




  };

  # overrides
  domain = base // {
    # https://docs.vrchat.com/docs/using-vrchat-in-a-virtual-machine
    # Anticheat spoof
    os = base.os // {
      smbios = {
        mode = "sysinfo";
      };
    };

    sysinfo = {
      type = "smbios";
      bios.entry = [
        {
          name = "vendor";
          value = "American Megatrends Inc.";
        }
        {
          name = "version";
          value = "F8";
        }

        {
          name = "date";
          value = "5/24/2019";
        }
      ];
      system.entry = [
        {
          name = "manufacturer";
          value = "Gigabyte Technology Co., Ltd.";
        }
        {
          name = "product";
          value = "Z390 UD";
        }

        {
          name = "version";
          value = "x.x";
        }
        {
          name = "serial";
          value = "Default String";
        }
        {
          name = "uuid";
          value = base.uuid;
        }
        {
          name = "sku";
          value = "Default String";
        }

        {
          name = "sku";
          value = "Default String";
        }
      ];
    };





    # Performance chasing tweaks
    vcpu = {
      count = 10;
      placement = "static";
    };

    cpu = {
      mode         = "host-passthrough";
      check        = "partial";
      migratable   = true;
      topology     = { sockets = 1; dies = 1; cores = 5; threads = 2; };
      cacheMode    = "passthrough";
    };

    cputune = {
      vcpupin = [
        { vcpu = 0; cpuset = "1";  }
        { vcpu = 1; cpuset = "7";  }
        { vcpu = 2; cpuset = "2";  }
        { vcpu = 3; cpuset = "8";  }
        { vcpu = 4; cpuset = "3";  }
        { vcpu = 5; cpuset = "9";  }
        { vcpu = 6; cpuset = "4";  }
        { vcpu = 7; cpuset = "10"; }
        { vcpu = 8; cpuset = "5";  }
        { vcpu = 9; cpuset = "11"; }
      ];

      emulatorpin = {
        cpuset = "0,6"; # 0 for host
      };
    };

    clock = base.clock // {
      timer = base.clock.timer ++ [
        {
          name = "tsc";
          present = true;
          mode = "native";
        }
      ];
    };

    features = base.features // {
      hyperv = base.features.hyperv // {
        mode = "passthrough"; # Helps hide VM + hyperv enlightenments
      };

      kvm.hidden.state = true; # 🤫
    };

    # Merge
    devices = base.devices // {
      disk = base.devices.disk ++ [
      {
        driver = { name = "qemu"; type = "qcow2"; };
        source = { file = "/var/lib/libvirt/images/steamlibrary.qcow2"; };
        target = { dev = "vdb"; bus = "virtio"; };
      }
    ];

      
      # FIXME why does opengl acceleration not work on AMD card


      # looking glass guide says memballoon causes problems with VFIO
      memballoon = {
        model="none";
      };


      # For looking glass
      graphics = base.devices.graphics // {
        type = "spice";

        # FIXME why cant these port options be set :( still works ok without but port needs to be 5900
        # autoport = false;
        # port = 5900;
        listen = {
          type = "address";
          address = "127.0.0.1";
        };
        gl = {
          enable = false;
        };
      };

      video = base.devices.video // {
        model = base.devices.video.model // {
          acceleration = { accel3d = false; };
        };
      };      


      hostdev = [
        # RTX 2070
        # TODO dynamically pass this in
        {
          mode = "subsystem";
          type = "pci";

          managed = true;
          source = {
            address = {
              domain = 0;
              bus = 1;
              slot = 0;
              function = 0;
            };
          };

          address = {
            type = "pci";
            domain = 0;
            bus = 6;
            slot = 0;
            function = 0;
          };

        }
        {
          mode = "subsystem";
          type = "pci";

          managed = true;
          source = {
            address = {
              domain = 0;
              bus = 1;
              slot = 0;
              function = 1;
            };
          };

          address = {
            type = "pci";
            domain = 0;
            bus = 7;
            slot = 0;
            function = 0;
          };

        }


      ];
    };

    # For looking glass
    # TODO magically apply all this bull shit with a function that eats domains
    #

    qemu-commandline = {
      arg = [
        { value = "-device"; }
        { value = "{'driver':'ivshmem-plain','id':'shmem0','memdev':'looking-glass'}"; }

        { value = "-object"; }
        { value = "{'qom-type':'memory-backend-file','id':'looking-glass','mem-path':'/dev/kvmfr0','size':${toString (ivshmem-size*1024*1024)},'share':true}"; }

      ];
    };
  };
in
NixVirt.lib.domain.writeXML domain
