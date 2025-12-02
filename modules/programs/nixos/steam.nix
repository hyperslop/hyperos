{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.steam.enable {
    programs.steam.enable = true; #steam don't launch without
    #programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;
  };
}
