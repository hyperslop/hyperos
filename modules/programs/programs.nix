# see default.nix

{

/* THE SINGLE SOURCE OF TRUTH FOR PROGRAMS ON HYPEROS */

  all = [
    /**** BASE ****/

    "home-manager" #required (probably ¯\_(ツ)_/¯ )
    "git"
    "bash"
    "htop"
    "fastfetch"
    "wget"
    "neovim"
    "nano"
    "libqalculate"
    "usbutils"
    "nettools"
    "inetutils"
    "exiftool"
    "dmidecode"
    "lm_sensors"
    "rar"
    "zulu25"

    /**** DESKTOP ****/

    "hyprland"
    "kde-plasma"
    "sddm-custom"

    /**** BASIC-APPS ****/

      /* CALCULATOR */
        "qalculate-qt"
      /* DOCUMENT EDITOR */
        "libreoffice-qt-fresh"
      /* IMAGE VIEWER */
        "qimgv"
        "feh"
      /* VIDEO VIEWER */
        "vlc"
        "mpv"
      /* MISC */
        "gnome-disk-utility"

    /**** ONLINE-COMMUNICATION ****/

      /* BROWSER */
        "firefox"
        "brave"
      /* GENERAL */
        "discord"

    /**** ONLINE-MEDIA ****/
      /* VIDEO */
        "yt-dlp"
        "freetube"
      /* IMAGE */
        "gallery-dl"
      /* MUSIC */
        "nicotine-plus"
        "spotify"
        "ncspot"
        "spotdl"
        "sonobus-flatpak"
      /* GENERAL */
        "qbittorrent"

    /**** CREATIVE-APPS ***/

      /* PHOTOGRAPHY */
        "darktable"
        "digikam"

        "xnviewmp-flatpak" #remove later?
        "geeqie" #remove later?
      /* IMAGES */
        "gimp"
        "krita"
        "imagemagick"
      /* MUSIC */
        "reaper"
      /* VIDEO */
        "davinci-resolve"
        "ffmpeg-full"
      /* 3D */
        "blender"
        "freecad"
      /* GAMES */
        "godot"
        "worldpainter"
        "vinegar"
      /* LOCAL-AI */
        "lmstudio"
      /* MAPS */
        "qgis"

    /**** FUN APPLICATIONS ****/

      "mandelbulber"
      "projectm_3"
      "ladybird"
      "celestia"

    /**** GAMING ****/

      "steam"
      "lutris"
      "prismlauncher"
      "sober"
      "mangohud"
      "protonplus"
      "steam-run-free"

      /* MOD STUFF */
        "satisfactorymodmanager"
      /* GAME EMULATION */
        "retroarch" #Emulator frontend for libretro

        "melonDS" #DS
        "azahar" #3DS
        "dolphin-emu" #Gamecube + Wii
        "cemu" #Wii U
        "ryubing" #Nintendo Switch
        "ppsspp" #PSP
        "pcsx2" #PS2
        "rpcs3" #PS3
        "shadps4" #PS4
        "xemu" #Xbox
        "xenia-canary" #Xbox 360
        "flycast" #Sega Dreamcast

        "libretro.gambatte" #Game Boy & Game Boy Color
        "libretro.mgba" #Game Boy Advanced
        "libretro.mesen" #NES
        "libretro.snes9x" #SNES
        "libretro.mupen64plus" #N64
        "libretro.swanstation" #PS1
        "libretro.beetle-saturn" #Sega Saturn
        "libretro.genesis-plus-gx" #Sega Genesis, SG-1000
        "libretro.mame" #Arcade Games

    /**** VIRTUALIZATION ****/

      "distrobox"
      "podman"
      "docker"
      "waydroid"

        /*** QEMU/KVM ***/

        "virt-manager"
        "virt-viewer"
        "spice"
        "spice-gtk"
        "spice-protocol"
        "libvirt"
        "qemu"
        "quickemu"
        "quickgui"
        "OVMF"

    /**** PRIVACY ****/

        "tor"
        "i2p"
        "mullvad"
        "protonvpn-gui"
        "monero-gui"
        "mullvad-browser"
        "tor-browser"
        "wireguard-tools"
        "opensnitch"
        "opensnitch-ui"

  ];

  packageSources = {
    davinci-resolve = "stable";
    azahar = "stable"; #compiles 10/28/25
    rpcs3 = "stable"; #compiles 10/28/25
    ollama = "stable"; #compiles 10/28/25
    ollama-cuda = "stable"; #compiles 10/28/25
    protonvpn-gui = "stable";
    python3 = "stable";
    shadps4 = "stable";

    sddm-custom = null;
    sonobus-flatpak = null;
    xnviewmp-flatpak = null;
    sober = null;
    kde-plasma = null;
  };
}
