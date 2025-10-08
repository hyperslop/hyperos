{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.kde-plasma.enable {
    services.desktopManager.plasma6.enable = true; #Enables KDE Plasma Desktop
    };
}
