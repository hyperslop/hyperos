# NixOS manual is accessible by running ‘nixos-help’

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      #put modules/nixos here
    ];

  networking.hostName = "default"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

}
