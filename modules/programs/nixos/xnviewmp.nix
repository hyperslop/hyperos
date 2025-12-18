{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.xnviewmp.enable {
    services.flatpak.enable = true;
    services.flatpak.packages = [
      { appId = "com.xnview.XnViewMP"; origin = "flathub"; }
    ];
  };
}
