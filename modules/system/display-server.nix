{ config, pkgs, inputs, ... }:
{
  services.xserver.enable = true; #Enables X11
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; #Fix wayland issues for chromium/electron apps
}
