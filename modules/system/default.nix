{ config, pkgs, inputs, lib, ... }:

{
  config = lib.mkIf config.hyperos.system.default.enable {
  };
}
