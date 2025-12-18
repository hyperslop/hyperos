{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware.nix
      ./../../homes/hyper/hyper.nix
      ./../../lib

      inputs.home-manager.nixosModules.default

    ];

  /* sometimes warning about this not set,
  It's set correctly after the entire config switches tho.
  if presist it has to do with lib/default.nix probably */
  system.stateVersion = "25.05";

  hyperos.programs.all.enable = true;
  hyperos.system.all.enable = true;
  hyperos.hardware.all.enable = true;
  #hyperos.profiles.basic.enable = true;

  hyperos.users = [ "hyper" ];
  home-manager = {
    useGlobalPkgs = true;    # Use system's nixpkgs
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs; };
    users = {
      "hyper" = import ./../../homes/hyper/home.nix;
    };
    #Don't know what this does but it makes home manager work
    backupFileExtension = "backup";
  };

  networking.hostName = "pc"; # Define your hostname.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 8554 ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

}
