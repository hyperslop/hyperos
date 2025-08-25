# NixOS manual is accessible by running ‘nixos-help’

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./../../users/hyper/hyper.nix

      ./../../modules/nixos/nixpkgs.nix
      ./../../modules/nixos/flatpak.nix

      inputs.home-manager.nixosModules.default
    ];


  home-manager = {
    extraSpecialArgs = {inherit inputs; };
    users = {
      "hyper" = import ./../../users/hyper/home.nix;
    };
    #Don't know what this does but it makes home manager work, fixes error message.
    backupFileExtension = "backup";
  };

  networking.hostName = "laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

}
