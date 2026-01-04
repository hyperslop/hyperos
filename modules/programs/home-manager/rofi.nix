{ config, pkgs, ... }:
{
programs.rofi = {
    enable = true;
    theme = "DarkBlue";
    modes = [
      "drun"
      "run"
      "window"
      "ssh"
    ];
    extraConfig = {
      show-icons = true;
    };
  };
}
