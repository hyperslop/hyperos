{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.wireguard-tools.enable {
    boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  };
}
