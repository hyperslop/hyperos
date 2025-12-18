{ config, pkgs, inputs, lib, ... }:

{
  config = lib.mkIf config.hyperos.hardware.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
  };
}
