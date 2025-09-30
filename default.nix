# NixOS manual is accessible by running ‘nixos-help’

{ config, pkgs, inputs, ... }:

{

  # Bootloader.

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking

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

  services.flatpak.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; #Fix wayland issues for chromium/electron apps

  # User Inital Settings

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "hyper";

  # Home Manager Initial Settings

  # Misc Program Settings

  #Steam settings
  programs.steam.enable = true; #steam don't launch without
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  #mullvad vpn settings
  services.mullvad-vpn.enable = true;
  services.resolved.enable = true;

  #podman settings
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  #Virtualisation settings
  virtualisation.libvirtd.enable = true;

  virtualisation.libvirtd.qemu = {
    package = pkgs.qemu_kvm;
    swtpm.enable = true;  # TPM emulation support
    ovmf.enable = true;   # UEFI support for VMs
  };



  system.stateVersion = "25.05";

}
