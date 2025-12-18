{ config, pkgs, inputs, lib, ... }:

{
  config = lib.mkIf config.hyperos.system.boot.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
