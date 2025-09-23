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
      wallpaper = "${pkgs.libsForQt5.plasma-workspace-wallpapers}/share/wallpapers/Kay/contents/images/1080x1920.png";
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

      # Virtual desktops configuration - 2 rows of 4 desktops
      "kwinrc" = {
        "Desktops" = {
          "Number" = 8;
          "Rows" = 2;
        };
      };

      # SDDM theme (login screen) - also set to dark
      "kscreenlockerrc" = {
        "Greeter" = {
          "Theme" = "breeze-dark";
        };
      };
    };

    # Virtual desktops configuration - 2 rows of 4 desktops
    configFile = {
      "kwinrc" = {
        "Desktops" = {
          "Number" = 8;
          "Rows" = 2;
        };
      };
    };

    # Desktop shortcuts for all 8 desktops
    shortcuts = {
      "kwin" = {
        # Row 1 (Top row)
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";

        # Row 2 (Bottom row)
        "Switch to Desktop 5" = "Meta+5";
        "Switch to Desktop 6" = "Meta+6";
        "Switch to Desktop 7" = "Meta+7";
        "Switch to Desktop 8" = "Meta+8";

        # Move windows to desktops
        "Window to Desktop 1" = "Meta+Shift+1";
        "Window to Desktop 2" = "Meta+Shift+2";
        "Window to Desktop 3" = "Meta+Shift+3";
        "Window to Desktop 4" = "Meta+Shift+4";
        "Window to Desktop 5" = "Meta+Shift+5";
        "Window to Desktop 6" = "Meta+Shift+6";
        "Window to Desktop 7" = "Meta+Shift+7";
        "Window to Desktop 8" = "Meta+Shift+8";

        # Navigate between desktops with arrow keys
        "Switch to Next Desktop" = "Meta+Right";
        "Switch to Previous Desktop" = "Meta+Left";
        "Switch Up" = "Meta+Up";
        "Switch Down" = "Meta+Down";
      };
    };
  };
}
