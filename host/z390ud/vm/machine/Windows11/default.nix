{ pkgs, lib, inputs, ... }:

let
  name = "Windows11";
  mkHook = path: pkgs.writeShellScript (baseNameOf path) (builtins.readFile path);
in
{
  imports = [
    ../../scopedHooks.nix
  ];


  # Add the domain
  virtualisation.libvirt.connections."qemu:///system".domains = lib.mkAfter [
    {
      definition = import ./xml.nix {
        inherit name;
        NixVirt = inputs.NixVirt;
      };

      active = false;
      restart = false;
    }
  ];

  # libvirtd.service needs to be restarted for this to update
  # Took way too long to realize that.
  virtualisation.libvirtd.enable = true;

  # FIXME make scripts to allow passing in GPU IDs


  # Kill anything using the GPU and Load VFIO drivers
  virtualisation.libvirtd.scopedHooks.qemu = {

    # GPU drivers
    "${name}-load_vfio" = {
      script = null;
      source = mkHook ../../load_vfio.sh;
      scope = {
        objects = [ name ];
        # Before VM
        operations = [ "prepare" ];
        subOperations = [ "begin" ];
      };
    };

    # Release GPU and load nvidia drivers
    "${name}-load_nvidia" = {
      script = null;
      source = mkHook ../../load_nvidia.sh;
      scope = {
        objects = [ name ];
        # VM has to be completely done
        operations = [ "stopped" ];
        subOperations = [ "end" ];
      };
    };

    # Scream
    "${name}-load_scream" = {
      script = null;
      source = mkHook ../../load_scream.sh;
      scope = {
        objects = [ name ];
        operations = [ "prepare" ];
        subOperations = [ "begin" ];
      };
    };

    "${name}-stop_scream" = {
      script = null;
      source = mkHook ../../unload_scream.sh;
      scope = {
        objects = [ name ];
        operations = [ "stopped" ];
        subOperations = [ "end" ];
      };
    };



    # Tuna
    "${name}-tuna_start" = {
      script = "tuna isolate --cputs=1-5,7-11";
      scope = {
        objects = [ name ];
        operations = [ "prepare" ];
        subOperations = [ "begin" ];
      };
    };
    "${name}-tuna_stop" = {
      script = "tuna include --cputs=1-5,7-11";
      scope = {
        objects = [ name ];
        operations = [ "stopped" ];
        subOperations = [ "end" ];
      };

    };


  };  

  systemd.services.libvirtd.path = with pkgs; [
    bash
    scream
    coreutils # tee
    procps # pkill
    sudo
    systemd

    tuna # messing with cores
  ];

}
