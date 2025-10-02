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
      };
    };
  };
}
