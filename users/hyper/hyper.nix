{ config, pkgs, inputs, lib, options, ... }:

{
  users.users.hyper = {
    isNormalUser = true;
    description = "hyper";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.kwalletmanager
    #  thunderbird
    ];
  };

#  programs.git = lib.mkIf (options.programs.git ? enable) {
#    userName = "hyperslop";
#    userEmail = "hyperslop@proton.me";
#  };
}

