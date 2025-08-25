# NixOS manual is accessible by running ‘nixos-help’

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./../../users/hyper/hyper.nix

      ./../../modules/nixos/nixpkgs.nix
      ./../../modules/nixos/flatpak.nix
    ];

  networking.hostName = "pc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

}
