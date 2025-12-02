{ config, pkgs, inputs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
    #git default branch is master, on git hosting sites its main.
	init.defaultBranch = "main";
	#solves dubious ownership warning
	safe.directory = "/etc/nixos/";
    };
  };
}
