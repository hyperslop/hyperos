{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.hyperos.hardware.nvidia.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

  services.xserver.enable = true;

  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  };
}
