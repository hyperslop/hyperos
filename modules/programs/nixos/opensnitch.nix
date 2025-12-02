{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.opensnitch.enable {
    services.opensnitch.enable = true;
  };
}
