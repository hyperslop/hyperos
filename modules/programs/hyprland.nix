{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.hyprland.enable {
    programs.hyprland.enable = true;
  };
}
