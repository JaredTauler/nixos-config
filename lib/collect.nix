# Recursively import nix in dir

{ lib }:
path:
  lib.flatten (lib.mapAttrsToList (name: type:
    if type == "regular" && lib.hasSuffix ".nix" name then
      [ (import (path + "/${name}")) ]
    else if type == "directory" then
      [ ((import ./collect.nix { inherit lib; }) (path + "/${name}")) ]
    else []
  ) (builtins.readDir path))
