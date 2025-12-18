{ config, pkgs, inputs, lib, ... }:
{
  config = lib.mkIf config.hyperos.system.display-server.enable {
    services.xserver.enable = true; #Enables X11
    environment.sessionVariables.NIXOS_OZONE_WL = "1"; #Fix wayland issues for chromium/electron apps
  };
}
