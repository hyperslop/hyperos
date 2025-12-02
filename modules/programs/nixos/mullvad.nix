{ config, lib, ... }:
{
  config = lib.mkIf config.hyperos.programs.mullvad.enable {
    services.mullvad-vpn.enable = true;
    services.resolved.enable = true;
  };
}
