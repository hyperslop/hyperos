# modules/home-manager/kde.nix
{ config, lib, pkgs, imports, inputs, ... }:
{
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  programs.plasma = {
    enable = true;

    # Set workspace theme to Breeze Dark
    workspace = {
      colorScheme = "BreezeDark";
      theme = "breeze-dark";
      iconTheme = "breeze-dark";
    };

    # Power management settings - disable screen timeout and sleep
    powerdevil = {
      AC = {
        autoSuspend = {
          action = "nothing";
        };
        turnOffDisplay = {
          idleTimeout = "never";
        };
        dimDisplay = {
          enable = false;
        };
      };
      battery = {
        autoSuspend = {
          action = "nothing";
        };
        turnOffDisplay = {
          idleTimeout = "never";
        };
        dimDisplay = {
          enable = false;
        };
      };
      lowBattery = {
        autoSuspend = {
          action = "nothing";
        };
      };
    };

    # Screen locker settings - disable automatic locking
    kscreenlocker = {
      autoLock = false;
      lockOnResume = false;
      timeout = null;
    };

    # Global theme configuration
    configFile = {
      "kdeglobals" = {
        "General" = {
          "ColorScheme" = "BreezeDark";
          "Name" = "Breeze Dark";
        };
        "KDE" = {
          "LookAndFeelPackage" = "org.kde.breezedark.desktop";
        };
      };

      # SDDM theme (login screen) - also set to dark
      "kscreenlockerrc" = {
        "Greeter" = {
          "Theme" = "breeze-dark";
        };
      };
    };

    # Virtual desktops configuration - 2 rows of 5 desktops
    configFile = {
      "kwinrc" = {
        "Desktops" = {
          "Number" = 10;
          "Rows" = 2;
        };
      };
    };

    # Desktop shortcuts for all 8 desktops
    shortcuts = {
      "kwin" = {
        # Switch between taskbar applications
        #"Activate Task Manager Entry 1" = "Meta+1";
        #"Activate Task Manager Entry 2" = "Meta+2";
        #"Activate Task Manager Entry 3" = "Meta+3";
        #"Activate Task Manager Entry 4" = "Meta+4";
        #"Activate Task Manager Entry 5" = "Meta+5";
        #"Activate Task Manager Entry 6" = "Meta+6";
        #"Activate Task Manager Entry 7" = "Meta+7";
        #"Activate Task Manager Entry 8" = "Meta+8";
        #"Activate Task Manager Entry 9" = "Meta+9";
        #"Activate Task Manager Entry 10" = "Meta+0";

        # Switch Desktops
        #"Switch to Desktop 1" = "Meta+Shift+1";
        #"Switch to Desktop 2" = "Meta+Shift+2";
        #"Switch to Desktop 3" = "Meta+Shift+3";
        #"Switch to Desktop 4" = "Meta+Shift+4";
        #"Switch to Desktop 5" = "Meta+Shift+5";
        #"Switch to Desktop 6" = "Meta+Shift+6";
        #"Switch to Desktop 7" = "Meta+Shift+7";
        #"Switch to Desktop 8" = "Meta+Shift+8";
        #"Switch to Desktop 9" = "Meta+Shift+8";
        #"Switch to Desktop 10" = "Meta+Shift+8";

        # Navigate between desktops with arrow keys
        #"Switch to Next Desktop" = "Meta+Right";
        #"Switch to Previous Desktop" = "Meta+Left";


        # Walk Through Windows
        #"Walk Through Windows" = "Alt+Tab";
        #"Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
        #"Walk Through Windows of Current Application" = "Alt+grave";
      };
    };
  };
}
