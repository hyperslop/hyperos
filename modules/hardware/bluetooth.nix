{ config, pkgs, inputs, ... }:

{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
