{ config, pkgs, inputs, lib, ... }:

{
  config = lib.mkIf config.hyperos.hardware.default.enable {
  };
}
