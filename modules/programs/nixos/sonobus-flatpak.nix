{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.sonobus-flatpak.enable {
    services.flatpak.enable = true;
    services.flatpak.packages = [
      { appId = "net.sonobus.SonoBus"; origin = "flathub"; }
    ];
  };
}
