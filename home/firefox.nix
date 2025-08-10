#https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions

{ config, pkgs, inputs, ... }:
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

  programs.firefox = {
    enable = true;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        Preferences = {
          "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
          "extensions.pocket.enabled" = lock-false;
          "extensions.screenshots.disabled" = lock-true;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.formfill.enable" = lock-false;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        };
      };

    profiles = {
      hyperslop = {
      id = 0;
      isDefault = true;
      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          privacy-badger
          sponsorblock
          return-youtube-dislikes
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
      };
      school = {
        id = 1;
        isDefault = false;
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          sponsorblock
          return-youtube-dislikes
          darkreader
        ];
      settings."extensions.autoDisableScopes" = 0; #enable extensions automatically
      };
      work = {
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
      anon = {
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
  };
}
