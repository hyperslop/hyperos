{ config, pkgs, inputs, lib,... }:

{
  config = lib.mkIf config.hyperos.system.nix.enable {
    nixpkgs.config.allowBroken = true; #Packages marked as broken, needed for python.
    nixpkgs.config.allowUnfree = true; #Unfree packages (FOSS)
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.substituters = [ "https://cache.nixos.org" ];
  };
}
