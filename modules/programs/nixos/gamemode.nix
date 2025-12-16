{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.gamemode.enable {
    programs.gamemode.enable = true;
  };
}
