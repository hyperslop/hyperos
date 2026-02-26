{ config, pkgs, inputs, lib, ... }:

{
  config = lib.mkIf config.hyperos.system.nix.enable {
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.substituters = [ "https://cache.nixos.org" ];

    # Automatically garbage collect old store paths weekly
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
