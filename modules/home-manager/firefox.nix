#https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions

{ config, pkgs, imports, inputs, ... }:
  let
    lock-false = {
      Value = false;
      Status = "locked";
    };
    lock-true = {
      Value = true;
      Status = "locked";
    };
  in
{
  imports = [
    inputs.arkenfox-nixos.hmModules.arkenfox
  ];

  programs.firefox = {
    enable = true;
      arkenfox = {
        enable = true;
        version = "master";
      };
      profiles = {
      ogfirefox = {
      id = 0;
      isDefault = false;
      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
      };
      default = {
      id = 1;
      isDefault = true;
      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          localcdn
          clearurls
          return-youtube-dislikes
          sponsorblock
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
        arkenfox = {
          enable = true;
          enableAllSections = true;
        };
      };
      anon = {
        id = 2;
        isDefault = false;
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          localcdn
          libredirect
          clearurls
          noscript
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
        arkenfox = {
          enable = true;
          enableAllSections = true;
        };
      };
      misc = {
        id = 3;
        isDefault = false;
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          localcdn
          clearurls
          return-youtube-dislikes
          sponsorblock
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
        arkenfox = {
          enable = true;
          enableAllSections = true;
        };
      };
      };
  };
}
