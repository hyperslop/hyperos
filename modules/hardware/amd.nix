{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.hyperos.hardware.amd.enable {

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        mesa
        #amdvlk
      ];
    };

  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.amdgpu.opencl.enable = true;

  #environment.variables.AMD_VULKAN_ICD = "RADV";
  };
}
