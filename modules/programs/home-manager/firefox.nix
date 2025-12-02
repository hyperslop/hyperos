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
      settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;
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
      settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        arkenfox = {
          enable = true;
          enableAllSections = true;
        };
        userChrome = ''
        #nav-bar::after {
          content: "D" !important;
          position: fixed !important;
          top: 52px !important;
          right: 12px !important;
          background-color: #ff7f7f !important;
          color: white !important;
          width: 23px !important;
          height: 24px !important;
          border-radius: 50% !important;
          display: flex !important;
          align-items: center !important;
          justify-content: center !important;
          font-weight: bold !important;
          z-index: 9999 !important;
          pointer-events: none !important;
        }
      '';
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
      settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        arkenfox = {
          enable = true;
          enableAllSections = true;
        };
        userChrome = ''
        #nav-bar::after {
          content: "A" !important;
          position: fixed !important;
          top: 52px !important;
          right: 12px !important;
          background-color: #000000 !important;
          color: white !important;
          width: 23px !important;
          height: 24px !important;
          border-radius: 50% !important;
          display: flex !important;
          align-items: center !important;
          justify-content: center !important;
          font-weight: bold !important;
          z-index: 9999 !important;
          pointer-events: none !important;
        }
      '';
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
      settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        arkenfox = {
          enable = true;
          enableAllSections = true;
        };
        userChrome = ''
        #nav-bar::after {
          content: "M" !important;
          position: fixed !important;
          top: 52px !important;
          right: 12px !important;
          background-color: #ffadff !important;
          color: white !important;
          width: 23px !important;
          height: 24px !important;
          border-radius: 50% !important;
          display: flex !important;
          align-items: center !important;
          justify-content: center !important;
          font-weight: bold !important;
          z-index: 9999 !important;
          pointer-events: none !important;
        }
      '';
      };
      };
  };

  home.packages = with pkgs; [
      (makeDesktopItem {
      name = "firefox-default";
      desktopName = "Firefox (Default)";
      exec = "firefox -P default --class=firefox-default";
      icon = "${../../../dotfiles/firefox-default.png}";
      categories = [ "Network" "WebBrowser" ];
      startupWMClass = "firefox-default";
    })
    (makeDesktopItem {
      name = "firefox-anon";
      desktopName = "Firefox (Anon)";
      exec = "firefox -P anon --class=firefox-anon";
      icon = "${../../../dotfiles/firefox-anon.png}";
      categories = [ "Network" "WebBrowser" ];
      startupWMClass = "firefox-anon";
    })
    (makeDesktopItem {
      name = "firefox-misc";
      desktopName = "Firefox (Misc)";
      exec = "firefox -P misc --class=firefox-misc";
      icon = "${../../../dotfiles/firefox-misc.png}";
      categories = [ "Network" "WebBrowser" ];
      startupWMClass = "firefox-misc";
    })
  ];
}
