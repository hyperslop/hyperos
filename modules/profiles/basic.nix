{ config, pkgs, inputs, lib, ... }:

{
  config = lib.mkIf config.hyperos.profiles.basic.enable {
    hyperos.system.locale.enable = lib.mkDefault true;
    hyperos.system.networking.enable = lib.mkDefault true;
    hyperos.system.nix.enable = lib.mkDefault true;
    hyperos.system.boot.enable = lib.mkDefault true;
  };
}
