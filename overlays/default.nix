{ inputs, system, ... }:

let
  overlayFiles = builtins.filter
    (f: f != "default.nix" && builtins.match ".*\\.nix" f != null)
    (builtins.attrNames (builtins.readDir ./.));
in
  map (f: import ./${f} { inherit inputs system; }) overlayFiles
