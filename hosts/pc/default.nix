{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware.nix
      ./../../homes/hyper/hyper.nix
      #./../../lib

      inputs.home-manager.nixosModules.default

    ];

  /* sometimes warning about this not set,
  It's set correctly after the entire config switches tho.
  if presist it has to do with lib/default.nix probably */
  system.stateVersion = "25.05";

  hyperos.programs.all.enable = true;
  hyperos.system.all.enable = true;
  hyperos.system.impermanence.enable = true;

  hyperos.hardware.all.enable = true;
  hyperos.hardware.nvidia.enable = false;

  #hyperos.vms.graphics-vm.enable = true;
  #hyperos.vms.mullvad-vpn-vm.enable = true;
  #hyperos.profiles.basic.enable = true;
  programs.nix-ld.enable = true;

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

  environment.systemPackages = with pkgs; [ flatpak-builder ];

  networking.hostName = "pc"; # Define your hostname.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 3001 ];

}
