{ config, lib, pkgs, ... }:

{
  imports =
    let
      # Get all .nix files in the current directory except default.nix
      nixFiles = builtins.filter
        (name: name != "default.nix" && lib.hasSuffix ".nix" name)
        (builtins.attrNames (builtins.readDir ./.));
    in
      map (name: ./. + "/${name}") nixFiles;
}
