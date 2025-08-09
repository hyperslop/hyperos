{ config, pkgs, inputs, ... }:

{
  imports = [
    ./home/firefox.nix
    ./home/git.nix
    ./home/hyprland.nix
  ];

  home.username = "hyper";
  home.homeDirectory = "/home/hyper";

  home.packages = [

  ];

  home.file = {

  };

  home.sessionVariables = {

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
