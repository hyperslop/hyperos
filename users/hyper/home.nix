{ config, pkgs, inputs, lib, options,  ... }:

{
  imports = [
    #./../../modules/home-manager/firefox.nix
    #./../../modules/home-manager/git.nix
    #./../../modules/home-manager/hyprland.nix
    #./../../modules/home-manager/kde.nix
    ./home-manager/firefox.nix
  ];

  home.username = "hyper";
  home.homeDirectory = "/home/hyper";

  home.packages = [

  ];

  home.file = {

  };

  home.sessionVariables = {

  };


  programs.git = lib.mkIf (options.programs.git ? enable) {
    userName = "hyperslop";
    userEmail = "hyperslop@proton.me";
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
