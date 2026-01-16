{ config, pkgs, inputs, lib, ... }:

{
  config = lib.mkIf config.hyperos.hardware.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.pipewire = {
    enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "bluetooth.ldac" = {
          "monitor.bluez.properties" = {
            "bluez5.enable-ldac" = true;
            #"bluez5.ldac.quality" = "hq"; # hq = 96k/24b
            };
          };
        };
      };
    };
  };
}
