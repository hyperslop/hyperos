{ config, pkgs, inputs, lib, options, ... }:

{
  users.users.default = {
    isNormalUser = true;
    description = "default";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}

