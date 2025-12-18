{ config, pkgs, inputs, lib, ... }:
{
  config = lib.mkIf config.hyperos.system.networking.enable {
    networking.networkmanager.enable = true;
  };
}
