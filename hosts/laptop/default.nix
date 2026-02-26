# NixOS manual is accessible by running ‘nixos-help’

{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [
      ./hardware.nix
      ./../../homes/hyper/hyper.nix
      ./../../lib


      inputs.home-manager.nixosModules.default
    ];


  hyperos.programs.all.enable = true;
  hyperos.system.all.enable = true;
  hyperos.system.impermanence.enable = true;
  hyperos.hardware.all.enable = true;
  hyperos.vms.graphics-vm.enable = false;
  hyperos.vms.mullvad-vpn-vm.enable = false;

  hyperos.hardware.nvidia.enable = lib.mkForce false;

  hyperos.users = [ "hyper" ];
  home-manager = {
    useGlobalPkgs = true;    # Use system's nixpkgs
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs; };
    users = {
      "hyper" = import ./../../homes/hyper/home.nix;
    };
    #Don't know what this does but it makes home manager work, fixes error message.
    backupFileExtension = "backup";
  };

  networking.hostName = "laptop"; # Define your hostname.
  networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 8554 ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

}
