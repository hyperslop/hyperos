{ config, pkgs, inputs, ... }:

{
  programs.git = {
    enable = true;
    userName = "hyperslop";
    userEmail = "hyperslop@proton.me";
    extraConfig = {
    #git default branch is master, on git hosting sites its main.
	init.defaultBranch = "main";
	#solves dubious ownership warning
	safe.directory = "/etc/nixos/";
    };
  };
}
