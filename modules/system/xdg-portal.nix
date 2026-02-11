{ config, pkgs, inputs, lib,... }:

{
  config = lib.mkIf config.hyperos.system.xdg-portal.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
      #xdgOpenUsePortal = true;
      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        };

        kde = {
          default = [ "kde" ];
          "org.freedesktop.impl.portal.Secret" = [ "kwallet" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "kde" ];
        };
      };
    };
  };
}
