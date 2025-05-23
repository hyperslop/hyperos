{ config, pkgs, inputs, ... }:

{
  imports = [
    ./home/firefox.nix
    ./home/git.nix
    ./home/hyprland.nix
  ];

  home.username = "hyperslop";
  home.homeDirectory = "/home/hyperslop";

  home.packages = [

  ];

  home.file = {

  };

  home.sessionVariables = {

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
