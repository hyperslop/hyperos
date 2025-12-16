{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.steam.enable {
    programs.steam.enable = true;
  };
}
