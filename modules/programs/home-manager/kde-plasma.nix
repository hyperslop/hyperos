{ config, lib, pkgs, imports, inputs, ... }:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  programs.plasma = {
    enable = true;

  hotkeys.commands."launch-rofi" = {
    name = "Launch Rofi";
    key = "Meta+Space";
    command = "rofi -show drun -show-icons -theme DarkBlue";
  };

  shortcuts = {
    "kwin" = {
      "Window Close" = "Ctrl+Q";
    };
  };

    workspace = {
      colorScheme = "BreezeDark";
      theme = "breeze-dark";
      iconTheme = "breeze-dark";
    };

    panels = [
      {
        location = "bottom";
        hiding = "autohide";

        # You might also want to configure these:
        height = 44;  # adjust to your preference

        widgets = [
          "org.kde.plasma.kickoff"           # Application launcher
          "org.kde.plasma.icontasks"         # Task manager (your taskbar)
          "org.kde.plasma.marginsseparator"  # Spacer
          "org.kde.plasma.systemtray"        # System tray
          "org.kde.plasma.digitalclock"      # Clock
          "org.kde.plasma.activitypager"
        ];
      }
    ];

    # Power management settings
    powerdevil = {
      AC = {
        autoSuspend = {
          action = "nothing";
        };
        turnOffDisplay = {
          idleTimeout = 300;
        };
        dimDisplay = {
          enable = true;
        };
      };
      battery = {
        autoSuspend = {
          action = "nothing";
        };
        turnOffDisplay = {
          idleTimeout = 300;
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
      "Windows" = {
        "Placement" = "Smart";  # Maximizing, Centered, Smart, Cascade, Random
      };
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
   # "plasmashellrc" = {
   #   "PlasmaViews"."Panel 1" = {
   #     "panelVisibility" = 1;  # 1 = auto-hide
   #   };
   # };


    };
  };



}
