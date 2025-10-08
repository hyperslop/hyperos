{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.hyperos.programs.sddm-custom.enable {
  environment.systemPackages = [(
  pkgs.catppuccin-sddm.override {
    flavor = "mocha";
    accent = "mauve";
    font  = "Noto Sans";
    fontSize = "9";
    #background = "${./wallpaper.webp}";
    loginBackground = true;
    }
  )];

  services.displayManager.sddm = {
    enable = lib.mkForce true;
    theme = lib.mkForce "catppuccin-mocha-mauve";
    package = lib.mkForce pkgs.kdePackages.sddm;
  };
};
}
