# NixOS manual is accessible by running ‘nixos-help’

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./../../users/hyper/hyper.nix

      ./../../modules/nixos/nixpkgs.nix
      ./../../modules/nixos/flatpak.nix
      ./../../modules/nixos/virtualisation.nix

      inputs.home-manager.nixosModules.default
    ];

  home-manager = {
    useGlobalPkgs = true;    # Use system's nixpkgs
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs; };
    users = {
      "hyper" = import ./../../users/hyper/home.nix;
    };
    #Don't know what this does but it makes home manager work, fixes error message.
    backupFileExtension = "backup";
  };

  networking.hostName = "pc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

}
