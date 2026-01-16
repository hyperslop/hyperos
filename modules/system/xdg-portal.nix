{ config, pkgs, inputs, lib,... }:

{
  config = lib.mkIf config.hyperos.system.xdg-portal.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
      config = {
        common = {
          default = [ "kde" ];
        };

        kde= {
          default = [ "kde" ];
          "org.freedesktop.impl.portal.Secret" = ["kwallet"];
          };
        };
        };
      };
    #  xdgOpenUsePortal = true;  # Force xdg-open to use portals
}
