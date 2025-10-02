# hyperos/modules/programs/steam.nix
{ lib, ... }:

let
  helpers = import ../../lib { inherit lib; };
in
helpers.mkProgramModule "steam" {
  # Steam package will be installed via the programs.steam.enable option, not environment.systemPackages
  # So we pass an empty string to prevent duplicate package installation
  packageName = "steam";

  # Add the Steam-specific system configuration
  extraConfig = {
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;
  };
}
