#https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions

{ config, pkgs, inputs, lib, options, ... }:

{

programs.firefox = lib.mkIf (options.programs.firefox ? enable) {
   profiles = {
      hyperslop = {
      id = 0;
      isDefault = true;
      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          sponsorblock
          return-youtube-dislikes
          darkreader
          clearurls
          dearrow
          decentraleyes
          LocalCDN
          don-t-fuck-with-paste
          faststream
          i-dont-care-about-cookies
          umatrix
          youtube-recommended-videos

        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
      };
      work = {
        id = 1;
        isDefault = false;
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          sponsorblock
          return-youtube-dislikes
          darkreader
        ];
        settings."uBlock0@raymondhill.net".settings = {
          selectedFilterLists = [
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-unbreak"
            "ublock-quick-fixes"
            "easylist-cookie-notices"
            "ublock-cookie-notices"

          ];

        };
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
      };
      school = {
        id = 2;
        isDefault = false;
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          sponsorblock
          return-youtube-dislikes
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
      };
      misc = {
        id = 3;
        isDefault = false;
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          sponsorblock
          return-youtube-dislikes
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
      };
      guest = {
        id = 4;
        isDefault = false;
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          sponsorblock
          return-youtube-dislikes
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
      };
    };
}
