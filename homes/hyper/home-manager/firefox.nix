#https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions

{ config, pkgs, inputs, lib, options, ... }:

{

programs.firefox = lib.mkIf (options.programs.firefox ? enable) {
   profiles = { # profiles: hyperslop, school, work, anon
      hyper = {
      id = 4;
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
      school = {
        id = 5;
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
      work = {
        id = 6;
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
