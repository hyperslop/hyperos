# NixOS manual is accessible by running ‘nixos-help’

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./../../homes/hyper/hyper.nix
      ./../../modules/programs

      inputs.home-manager.nixosModules.default
    ];

  hyperos.programs.all.enable = true;

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
    networking.firewall.allowedTCPPorts = [ 8554 ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

}
