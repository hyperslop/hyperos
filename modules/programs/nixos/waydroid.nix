{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.waydroid.enable {
  virtualisation.waydroid.enable = true;
};
}

