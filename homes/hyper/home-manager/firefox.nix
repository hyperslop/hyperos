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
      settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        arkenfox = {
          enable = true;
          enableAllSections = true;
        };
        userChrome = ''
        #nav-bar::after {
          content: "H" !important;
          position: fixed !important;
          top: 52px !important;
          right: 12px !important;
          background-color: #2b179e !important;
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
      settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        arkenfox = {
          enable = true;
          enableAllSections = true;
        };
        userChrome = ''
        #nav-bar::after {
          content: "S" !important;
          position: fixed !important;
          top: 52px !important;
          right: 12px !important;
          background-color: #b2ffff !important;
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
      settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        arkenfox = {
          enable = true;
          enableAllSections = true;
        };
        userChrome = ''
        #nav-bar::after {
          content: "W" !important;
          position: fixed !important;
          top: 52px !important;
          right: 12px !important;
          background-color: #adffad !important;
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
      name = "firefox-hyper";
      desktopName = "Firefox (Hyper)";
      exec = "firefox -P hyper --class=firefox-hyper";
      icon = "${../../../dotfiles/firefox-hyper.png}";
      categories = [ "Network" "WebBrowser" ];
      startupWMClass = "firefox-hyper";
    })
    (makeDesktopItem {
      name = "firefox-school";
      desktopName = "Firefox (School)";
      exec = "firefox -P school --class=firefox-school";
      icon = "${../../../dotfiles/firefox-school.png}";
      categories = [ "Network" "WebBrowser" ];
      startupWMClass = "firefox-school";
    })
    (makeDesktopItem {
      name = "firefox-work";
      desktopName = "Firefox (Work)";
      exec = "firefox -P work --class=firefox-work";
      icon = "${../../../dotfiles/firefox-work.png}";
      categories = [ "Network" "WebBrowser" ];
      startupWMClass = "firefox-work";
    })
  ];
}
