# Recursively import nix in dir

# { lib, handle }:
# path:
#   lib.flatten (lib.mapAttrsToList (name: type:
#     if type == "regular" && lib.hasSuffix ".nix" name then
#       [ handle ]
#     else if type == "directory" then
#       [ ((import ./collect.nix { inherit lib; }) (path + "/${name}")) ]
#     else []
#   ) (builtins.readDir path))
# { lib }:
# { path, handle }:

# lib.flatten (lib.mapAttrsToList (name: type:
#   if type == "regular" && lib.hasSuffix ".nix" name then
#     [ (handle (path + "/${name}")) ]
#   else if type == "directory" then
#     [ (import ./collect.nix { inherit lib; }) { inherit handle; path = path + "/${name}"; } ]
#   else
#     []
# ) (builtins.readDir path))

{ lib }:
let
  go = { path, handle, ... }:
    lib.flatten (lib.mapAttrsToList (name: type:
      let fullPath = path + "/${name}";
      in
      if type == "regular" && lib.hasSuffix ".nix" name then
        [ (handle fullPath) ]
      else if type == "directory" then     
        go { inherit handle; path = fullPath; }
      else
        []
    ) (builtins.readDir path));
in
  go
