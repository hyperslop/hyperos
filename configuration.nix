# Help is available in the configuration.nix(5) man page
# NixOS manual is accessible by running ‘nixos-help’

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      inputs.home-manager.nixosModules.default #home.nix
    ];

  # Bootloader.

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Initial Settings

  networking.networkmanager.enable = true;
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Display Protocol

  services.xserver.enable = true; #Enables X11

  # Desktop Environment

  services.displayManager.sddm.enable = true; #Enables SDDM Display Manager/Login Manager

  services.desktopManager.plasma6.enable = true; #Enables KDE Plasma Desktop

  programs.hyprland.enable = true;
  #programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  # Sound Settings

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Misc Initial Settings

  services.xserver.xkb = { # X11 Keyboard Settings
    layout = "us";
    variant = "";
  };

  services.printing.enable = true; # Enable CUPS to print documents.

  nixpkgs.config.allowBroken = true; #Packages marked as broken, needed for python.

  nixpkgs.config.allowUnfree = true; #Unfree packages (FOSS)

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; #Fix wayland issues for chromium/electron apps

  # User Inital Settings

  users.users.hyperslop = {
    isNormalUser = true;
    description = "hyperslop";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.kwalletmanager
    #  thunderbird
    ];
  };

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "hyperslop";

  # Home Manager Initial Settings

  home-manager = {
    extraSpecialArgs = {inherit inputs; };
    users = {
      "hyperslop" = import ./home.nix;
    };
    #Don't know what this does but it makes home manager work, fixes error message.
    backupFileExtension = "backup";
  };

  # Misc Program Settings

  #Steam settings
  programs.steam.enable = true; #steam don't launch without
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #tools:
      home-manager
      neovim
      vim
      wget
      git
      htop
      libqalculate
      yt-dlp
      fastfetch
      kitty
      projectm_3
      mandelbulber
      qalculate-qt
      hyprland
    #creative apps:
      gimp
      krita
      reaper
      blender
      freecad
      #cura # failes to build :(
      #davinci-resolve # builds, takes to long, need pro for h264 i think anyway. figure out later.
      godot
      worldpainter
      qgis
    #media apps
      steam
        mangohud
      lutris
      retroarch
      prismlauncher
      spotify #alternative client?
      ncspot
      nicotine-plus
    #social apps
      firefox
      ungoogled-chromium
      discord #alternative client?
    #super secret! dont tell the feds!
      tor
      i2p
      qbittorrent
      mullvad-vpn
      monero-gui
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
