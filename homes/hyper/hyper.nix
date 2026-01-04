{ config, pkgs, inputs, lib, options, ... }:

{
  users.users.hyper = {
    isNormalUser = true;
    description = "hyper";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm"];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.kwalletmanager
    ];
  };
}

