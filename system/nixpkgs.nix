{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [

  /***** General Tools *****/

    home-manager
    hyprland
    kitty
    htop
    fastfetch
    libqalculate
    qalculate-qt

  /******************* Media *******************/
  /* Tools for viewing or making media locally */
  /*********************************************/

    #text
      neovim
      vim
      libreoffice-qt-fresh
      jetbrains.idea-community-bin
        #intellij-addons
        github-copilot-intellij-agent
    #images
      cheese
      #creative
      gimp
      krita
    #video
      vlc
      #creative
        davinci-resolve # builds, takes to long, need pro for h264 i think anyway. figure out later.
    #music
      projectm_3
      #creative
        reaper
    #games
      lutris
      retroarch
      prismlauncher
      #creative
        godot
        worldpainter
    #3D
      #creative
        blender
        freecad
        #cura #fails to build
        mandelbulber
    #general
      #creative
        qgis

  /****************** Internet ******************/
  /* Tools for getting/sharing media externally */
  /**********************************************/

    #text
    #images
    #video
      yt-dlp
    #music
      spotify
      ncspot
      nicotine-plus
    #games
      steam
    #general
      wget
      git
      qbittorrent
      i2p
      #browsers
        firefox
        ungoogled-chromium
        tor
      #social
        discord
    #never go free willy
      mullvad-vpn
    #dont tell the feds
      monero-gui
  ];
}
