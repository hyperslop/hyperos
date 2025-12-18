{ config, pkgs, inputs, lib, options, ... }:

{
  imports = [
    inputs.arkenfox-nixos.hmModules.arkenfox
  ];

programs.firefox = lib.mkIf (options.programs.firefox ? enable) {
    enable = true;
      arkenfox = {
        enable = true;
        version = "master";
        };
   profiles = { # profiles: hyperslop, school, work, anon
      ogfirefox = {
        id = 0;
        isDefault = false;
        search.force = true; #Force overwrite search configs that conflict with home-manager
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
	search.default = "ddg";
	search.force = true; #Force overwrite search configs that conflict with home-manager
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
	search.default = "ddg";
	search.force = true; #Force overwrite search configs that conflict with home-manager
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
	search.default = "ddg";
	search.force = true; #Force overwrite search configs that conflict with home-manager
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
	search.default = "ddg";
	search.force = true; #Force overwrite search configs that conflict with home-manager
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
	search.default = "ddg";
	search.force = true; #Force overwrite search configs that conflict with home-manager
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
	search.default = "ddg";
	search.force = true; #Force overwrite search configs that conflict with home-manager
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
