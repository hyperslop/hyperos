{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.hyperos.vms.default.enable {
    #hyperos.programs.qemu_full.enable = lib.mkDefault true;

    #microvm.host.enable = true;

   # networking.nat = {
   #   enable = true;
   #   internalInterfaces = ["microvm"];
   # };
  };
}
