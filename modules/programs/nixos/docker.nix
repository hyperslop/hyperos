# modules/programs/docker.nix
{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.docker.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };
  };
}
