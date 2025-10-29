# modules/home-manager/kde.nix
{ config, lib, pkgs, imports, inputs, ... }:
{
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  programs.plasma = {
    enable = true;

    workspace = {
      colorScheme = "BreezeDark";
      theme = "breeze-dark";
      iconTheme = "breeze-dark";
    };

    # Power management settings
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

    kscreenlocker = {
      autoLock = false;
      lockOnResume = false;
      timeout = null;
    };


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

      "kscreenlockerrc" = {
        "Greeter" = {
          "Theme" = "breeze-dark";
        };
      };

      "kwinrc" = {
        "Desktops" = {
          "Number" = 10;
          "Rows" = 2;
        };
      };

      ksmserverrc = {
        General = {
          loginMode = "emptySession";
        };
      };
    };
  };
}
