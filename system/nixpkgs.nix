{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [

    /***** Tools *****/

    hyprland
    kitty
    htop
    fastfetch
    libqalculate
    qalculate-qt
    python3
    usbutils

      /*** Virtualization, Emulation ***/

      distrobox
      podman
      docker
      waydroid

      /* Game Emulators */

        retroarch #Emulator frontend for libretro

        melonDS #DS
        azahar #3DS
        dolphin-emu #Gamecube + Wii
        cemu #Wii U
        ryubing #Nintendo Switch
        ppsspp #PSP
        duckstation #PS1
        pcsx2 #PS2
        rpcs3 #PS3
        shadps4 #PS4
        xemu #Xbox
        xenia-canary #Xbox 360
        flycast #Sega Dreamcast

        libretro.beetle-saturn #Sega Saturn
        libretro.genesis-plus-gx #Sega Genesis, SG-1000
        libretro.gambatte #Game Boy & Game Boy Color
        libretro.mgba #Game Boy Advanced
        libretro.mesen #NES
        libretro.snes9x #SNES
        libretro.mupen64plus #N64
        libretro.beetle-vb #VirtualBoy
        libretro.mame #Arcade Games

  /***** System Management *****/

    home-manager

  /***** Media Playback *****/

    /* Text */

    /* Image */

    /* Music */

      projectm_3

    /* Video */

      vlc

    /* Games */

      lutris
      prismlauncher

  /***** Creating *****/

    /* Text */

      neovim
      vim
      nano
      jetbrains.idea-community-bin
        #[Addons]#
          github-copilot-intellij-agent
      libreoffice-qt-fresh

    /* Images */

      gimp
      krita

    /* Music */

      reaper

    /* Video */

      #davinci-resolve # builds, takes to long, need pro for h264 i think anyway. figure out later.

    /* 3D */

      godot
      worldpainter
      blender
      freecad
      #cura #fails to build

    /* Misc */

        qgis
        mandelbulber

  /***** The Internet *****/

    /* Text */

      discord

    /* Image */

      gallery-dl

    /* Music */

      nicotine-plus
      spotify
      ncspot
      spotdl

    /* Video */

      yt-dlp

    /* Games */

      steam

    /* General */

      media-downloader
      qbittorrent
      wget
      git

      #[Browsers]#

        firefox
        brave
        ladybird
        mullvad-browser
        tor-browser

      #[Privacy Tools]#

        tor
        i2p
        mullvad-vpn
        monero-gui

  ];
}
