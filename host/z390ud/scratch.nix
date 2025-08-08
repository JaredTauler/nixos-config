with import <nixpkgs> { };
let
  NixVirt = {
    url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
    inputs.nixpkgs.follows = "nixpkgs";
  };
in writeText "vm.xml" (NixVirt.lib.domain.writeXML (let
  base = NixVirt.lib.domain.templates.windows {
    name = "Windows11";
    uuid = "13f0f0bd-a464-492b-832f-a7b07cd0ee4f";
    memory = {
      count = 10;
      unit = "GiB";
    };
    storage_vol = {
      pool = "default";
      volume = "win11.qcow2";
    };
    install_vol = "/var/lib/libvirt/images/Win11.iso";
    nvram_path = "/var/lib/libvirt/qemu/nvram/win11_VARS.fd";
    virtio_net = true;
    virtio_drive = true;
    install_virtio = true;
    secure = true;

    active = false;
  };

in base // {
  # Merge
  devices = base.devices // {
    # graphics = {
      #   type = "spice";
      #   listen = { type = "none"; };
      #   image = { compression = false; };
      #   # Do NOT include the `gl` field
      # };
      video = [

      ];

      shmem = [
        {
          name  = "looking‑glass";
          # model = { type = "ivshmem‑plain"; };
          # size  = {
          #   unit  = "M";
          #   value = 32;
          # };
          # address = {
            #   type     = "pci";
            #   domain   = 0;
            #   bus      = 0;
            #   slot     = 0;
            #   function = 0;
            # };
        }
      ];


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

      ];
  };
}))
