#https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions

{ config, pkgs, inputs, lib, options, ... }:

{

programs.firefox = lib.mkIf (options.programs.firefox ? enable) {
   profiles = { # profiles: hyperslop, school, work, anon
      hyper = {
      id = 3;
      isDefault = false;
      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          localcdn
          clearurls
          return-youtube-dislikes
          sponsorblock
          dearrow
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
      };
      school = {
        id = 4;
        isDefault = false;
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          localcdn
          clearurls
          return-youtube-dislikes
          sponsorblock
          dearrow
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
      };
      work = {
        id = 5;
        isDefault = false;
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          localcdn
          clearurls
          return-youtube-dislikes
          sponsorblock
          dearrow
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
      };
      };
    };
}
