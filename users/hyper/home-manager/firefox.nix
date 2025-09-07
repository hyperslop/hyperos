#https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions

{ config, pkgs, inputs, lib, options, ... }:

{

programs.firefox = lib.mkIf (options.programs.firefox ? enable) {
   profiles = { # profiles: hyperslop, school, work, anon
      hyper = {
      id = 100;
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
      school = {
        id = 101;
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
      work = {
        id = 102;
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
