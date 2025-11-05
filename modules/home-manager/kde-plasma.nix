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

    panels = [
      {
        location = "bottom";
        hiding = "autohide";

        # You might also want to configure these:
        height = 44;  # adjust to your preference

        widgets = [
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
   # "plasmashellrc" = {
   #   "PlasmaViews"."Panel 1" = {
   #     "panelVisibility" = 1;  # 1 = auto-hide
   #   };
   # };
    };
  };

  home.file.".config/plasmashellrc".text = ''
    [Panel]
    AutoHide=true
    ShowOnHover=false
  '';
}
