{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.hyperos.system.impermanence.enable {

    # Persistent password file since /etc/shadow is wiped each boot
    users.users.hyper.hashedPasswordFile = "/persist/system/passwords/hyper";

    # System-level persistence
    environment.persistence."/persist/system" = {
      hideMounts = true;

      directories = [
        "/etc/nixos"
        "/etc/NetworkManager/system-connections"
        "/etc/mullvad-vpn"
        "/etc/opensnitchd"
        "/etc/ssh"
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/timers"
        "/var/lib/NetworkManager"
        "/var/lib/bluetooth"
        "/var/lib/cups"
        "/var/lib/sddm"
        "/var/lib/docker"
        "/var/lib/libvirt"
        "/var/lib/waydroid"
        "/var/lib/flatpak"
        "/var/lib/opensnitch"
        "/var/lib/sops-nix"
        "/var/lib/pipewire"
        "/var/lib/microvms"
        "/var/cache/mullvad-vpn"
      ];

      files = [
        "/etc/machine-id"
      ];
    };

    # User-level persistence
    environment.persistence."/persist" = {
      hideMounts = true;

      users.hyper = {
        directories = [
          # hyperos
          "hyperos"

          # Browser
          ".mozilla"

          # Keys & crypto
          ".ssh"
          ".gnupg"

          # KDE / Plasma
          ".config/kde.org"
          ".config/kdedefaults"
          ".local/share/kwalletd"
          ".local/share/kscreen"
          ".local/share/baloo"
          ".local/share/plasma"

          # Media & communication
          ".config/FreeTube"
          ".config/discord"
          ".config/spotify"
          ".config/qBittorrent"
          ".config/obs-studio"
          ".config/vlc"
          ".config/mpv"

          # Creative
          ".config/GIMP"
          ".config/krita"
          ".config/darktable"
          ".config/digikam"
          ".config/blender"
          ".config/REAPER"
          ".local/share/DaVinciResolve"
          ".config/FreeCAD"

          # Development
          ".claude"
          ".config/godot"
          ".config/VSCodium"
          ".vscode-oss"
          ".config/LM Studio"

          # Gaming - emulators
          ".config/retroarch"
          ".config/melonDS"
          ".config/azahar"
          ".config/dolphin-emu"
          ".config/Cemu"
          ".config/rpcs3"
          ".config/shadps4"
          ".config/PCSX2"
          ".config/ppsspp"
          ".config/Ryujinx"
          ".local/share/xemu"

          # Gaming - launchers
          ".local/share/Steam"
          ".local/share/lutris"
          ".local/share/PrismLauncher"

          # Containers & VMs
          ".local/share/containers"
          ".local/share/libvirt"
          ".local/share/waydroid"

          # VPN & networking
          ".config/protonvpn"

          # Crypto
          ".local/share/monero-wallet-gui"

          # User data directories
          "Documents"
          "Downloads"
          "Pictures"
          "Videos"
          "Music"
          "Desktop"
        ];

        files = [
          ".bash_history"
          ".claude.json"
          ".config/kwinoutputconfig.json"
          ".config/plasma-org.kde.plasma.desktop-appletsrc"
          ".config/plasmashellrc"
          ".local/share/user-places.xbel"
        ];
      };
    };

    # Sync symlinked files back to persist every 5 minutes
    # Needed because atomic writes (rename) replace symlinks with real ephemeral files
    home-manager.users.hyper = {
      systemd.user.services.persist-sync = {
        Unit.Description = "Sync files to persist";
        Service = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "persist-sync" ''
            for file in \
              .claude.json \
              .config/kwinoutputconfig.json \
              .config/plasma-org.kde.plasma.desktop-appletsrc \
              .config/plasmashellrc \
              .local/share/user-places.xbel
            do
              [ -f "$HOME/$file" ] && ${pkgs.coreutils}/bin/cp -u "$HOME/$file" "/persist/home/hyper/$file"
            done
          '';
        };
      };

      systemd.user.timers.persist-sync = {
        Unit.Description = "Sync files to persist every 5 minutes";
        Timer = {
          OnBootSec = "5min";
          OnUnitActiveSec = "5min";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };

    # Allow bind mounts for user namespaces (needed for allowOther)
    programs.fuse.userAllowOther = true;
  };
}
