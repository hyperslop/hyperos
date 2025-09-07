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
      policies = {
        };
      Preferences = {
        };
      profiles = {
      default = {
      id = 0;
      isDefault = true;
      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          LocalCDN
          clearurls
          youtube-recommended-videos
          return-youtube-dislikes
          sponsorblock
          dearrow
          faststream
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
        arkenfox = {
          enable = true;
          enableAllSections = true;
        };
      };
      anon = {
        id = 1000;
        isDefault = false;
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          LocalCDN
          libredirect
          clearurls
          noscript
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
      };
      misc = {
        id = 2000;
        isDefault = false;
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          LocalCDN
          clearurls
          youtube-recommended-videos
          return-youtube-dislikes
          sponsorblock
          dearrow
          faststream
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
      };
      };
  };
}
