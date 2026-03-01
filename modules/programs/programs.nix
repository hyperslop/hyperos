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
    "fuse-overlayfs"
    "gcc"
    "pciutils"

    "bottles"
    "vital"
    "tcpdump"

    "mesa-demos"
    "vulkan-tools"

    "nftables"
    "dnsutils"

    "p7zip"
    "amf"

    "obs-studio"

    "clinfo"
    "gpu-viewer"
    "rstudioWrapper"

    "nodsjs"

    "vscodium-fhs"
    "psmisc"
    "dwarfs"

    "claude-code"
    /**** DESKTOP ****/

    "hyprland"
    "kde-plasma"
    "sddm"
    "rofi"

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
        "kdePackages.kdeconnect-kde"

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
        "sonobus"
      /* GENERAL */
        "qbittorrent"

    /**** CREATIVE-APPS ***/

      /* PHOTOGRAPHY */
        "darktable"
        "digikam"

        "xnviewmp" #remove later?
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
      "synthesia"
      "neothesia"

    /**** GAMING ****/

      "steam"
      "lutris"
      "prismlauncher"
      "sober"
      "mangohud"
      "protonplus"
      "steam-run-free"
      "gamescope"
      "gamemode"

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
      "wine-staging"	

        /*** QEMU/KVM ***/

        "virt-manager"
        "virt-viewer"
        "spice"
        "spice-gtk"
        "spice-protocol"
        "libvirt"
        "qemu_full"
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
    azahar = "stable";
    rpcs3 = "stable";
    ollama = "stable";
    ollama-cuda = "stable";
    protonvpn-gui = "stable";
    shadps4 = "stable";
    flycast = "stable";
    qgis = "stable";
    krita = "stable";
    dwarfs = "stable";
    rstudioWrapper = "stable";
    freecad = "stable";


    sonobus = "flatpak";
    xnviewmp = "flatpak";
    sober = "flatpak";

    sddm = null;
    kde-plasma = null;
    obs-studio = null;
  };
}
