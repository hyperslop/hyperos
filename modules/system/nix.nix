{ config, pkgs, inputs, lib, ... }:

{
  config = lib.mkIf config.hyperos.system.nix.enable {
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.substituters = [ "https://cache.nixos.org" ];
  };
}
