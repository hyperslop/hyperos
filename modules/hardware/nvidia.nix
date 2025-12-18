{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.hyperos.hardware.nvidia.enable {
    hardware.graphics = {
      enable = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {

      modesetting.enable = true;

      powerManagement.enable = false;

      powerManagement.finegrained = false;

      open = false; #use nvidia open source kernal module

    nvidiaSettings = true; #enable nvidia nvidiaSettings

      package = config.boot.kernelPackages.nvidiaPackages.beta;

    };
  };
}
