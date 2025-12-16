{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.gamescope.enable {
    programs.gamescope.enable = true;
    programs.steam.gamescopeSession.enable = true;
  };
}
