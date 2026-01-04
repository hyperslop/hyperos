{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware.nix
      ./../../homes/hyper/hyper.nix
      ./../../lib

      inputs.home-manager.nixosModules.default

    ];

  /* sometimes warning about this not set,
  It's set correctly after the entire config switches tho.
  if presist it has to do with lib/default.nix probably */
  system.stateVersion = "25.05";

  hyperos.programs.all.enable = true;
  hyperos.system.all.enable = true;

  hyperos.hardware.all.enable = true;
  hyperos.hardware.nvidia.enable = false;

  hyperos.vms.graphics-vm.enable = true;
  #hyperos.vms.graphics-vm-old.enable = true;
  hyperos.vms.mullvad-vpn-vm.enable = true;
  #hyperos.profiles.basic.enable = true;

  hyperos.users = [ "hyper" ];
  home-manager = {
    useGlobalPkgs = true;    # Use system's nixpkgs
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs; };
    users = {
      "hyper" = import ./../../homes/hyper/home.nix;
    };
    #Don't know what this does but it makes home manager work
    backupFileExtension = "backup";
  };

  networking.hostName = "pc"; # Define your hostname.
  networking.firewall.enable = true;
  networking.firewall.extraCommands = ''
    # Allow forwarding between the two VM networks
    iptables -A FORWARD -i vm-graphics -o vm-mullvad -j ACCEPT
    iptables -A FORWARD -i vm-mullvad -o vm-graphics -m state --state RELATED,ESTABLISHED -j ACCEPT

    # Allow graphics-vm to reach mullvad-vm's network
    iptables -A FORWARD -s 10.0.1.0/24 -d 10.0.0.0/24 -j ACCEPT
    iptables -A FORWARD -s 10.0.0.0/24 -d 10.0.1.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT

    # NAT traffic from graphics-vm so it appears to come from the host when going to mullvad-vm
    iptables -t nat -A POSTROUTING -s 10.0.1.0/24 -d 10.0.0.0/24 -j SNAT --to-source 10.0.0.1

    # Block graphics-vm from accessing host services directly
    iptables -A INPUT -i vm-graphics -d 10.0.1.1 -p tcp --dport 22 -j DROP
    iptables -A INPUT -i vm-graphics -j DROP

    # Prevent graphics-vm from accessing other private networks directly
    iptables -A FORWARD -i vm-graphics -d 192.168.0.0/16 -j DROP
    iptables -A FORWARD -i vm-graphics -d 172.16.0.0/12 -j DROP

    # Allow graphics-vm to reach its own network and mullvad network
    iptables -A FORWARD -i vm-graphics -d 10.0.1.0/24 -j ACCEPT
    iptables -A FORWARD -i vm-graphics -d 10.0.0.0/24 -j ACCEPT

    # Block all other 10.0.0.0/8 destinations
    iptables -A FORWARD -i vm-graphics -d 10.0.0.0/8 -j DROP
  '';

  #boot.kernel.sysctl = {
  #  "net.ipv4.ip_forward" = 1;
  #  "net.ipv6.conf.all.forwarding" = 1;
  #};
  #networking.firewall.allowedTCPPorts = [ 8554 ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

}
