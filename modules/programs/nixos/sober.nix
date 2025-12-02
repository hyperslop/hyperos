# modules/programs/sober.nix
{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.sober.enable {
    services.flatpak.enable = true;
    services.flatpak.packages = [
      { appId = "org.vinegarhq.Sober"; origin = "flathub"; }
    ];
  };
}
