{ config, pkgs, inputs, ... }:

{
  nixpkgs.config.allowBroken = true; #Packages marked as broken, needed for python.
  nixpkgs.config.allowUnfree = true; #Unfree packages (FOSS)
  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.05";
}
