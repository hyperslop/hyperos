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
  programs.nix-ld.enable = true;

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
  networking.firewall.allowedTCPPorts = [ 3001 ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
  };

  # Define routing table name
  networking.iproute2 = {
    enable = true;
    rttablesExtraConfig = ''
      100 graphics-vm
    '';
  };
  #networking.defaultGateway = {
  #  address = "10.0.0.2";
  #  interface = "vm-mullvad";
  #};
  networking.firewall.checkReversePath = "loose";
  networking.firewall.extraCommands = ''
    # Allow forwarding between VMs
    iptables -A FORWARD -i vm-graphics -o vm-mullvad -j ACCEPT
    iptables -A FORWARD -i vm-mullvad -o vm-graphics -m state --state RELATED,ESTABLISHED -j ACCEPT

    # Block graphics-vm from accessing other private networks
    iptables -A FORWARD -i vm-graphics -d 192.168.0.0/16 -j DROP
    iptables -A FORWARD -i vm-graphics -d 172.16.0.0/12 -j DROP

    # NAT traffic from graphics-vm through mullvad
    iptables -t nat -A POSTROUTING -s 10.0.1.0/24 -o vm-mullvad -j MASQUERADE

    # Block graphics-vm from accessing host services
    iptables -A INPUT -i vm-graphics -d 10.0.1.1 -p tcp --dport 22 -j DROP
    iptables -A INPUT -i vm-graphics -j DROP
  '';

  systemd.services.setup-graphics-vm-routing = {
    description = "Setup policy routing for graphics-vm";
    after = [ "network.target" "systemd-networkd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

  script = ''
    # Remove old rule if it exists
    ${pkgs.iproute2}/bin/ip rule del from 10.0.1.0/24 table 100 2>/dev/null || true

    # Add the policy routing rule
    ${pkgs.iproute2}/bin/ip rule add from 10.0.1.0/24 table 100 priority 100

    echo "Policy routing rule created:"
    ${pkgs.iproute2}/bin/ip rule show | grep "from 10.0.1.0/24"

    # First, ensure local network is always accessible
    ${pkgs.iproute2}/bin/ip route add 192.168.0.0/24 via 192.168.0.1 dev wlp7s0 metric 50 || true

    # Ensure WireGuard endpoint is routable (if not already handled)
    ${pkgs.iproute2}/bin/ip route add 23.168.216.127 via 192.168.0.1 dev wlp7s0 || true

    # Now set default route through VPN
    ${pkgs.iproute2}/bin/ip route del default via 192.168.0.1 || true
    ${pkgs.iproute2}/bin/ip route add default via 10.0.0.2 dev vm-mullvad metric 100
  '';

  preStop = ''
    ${pkgs.iproute2}/bin/ip rule del from 10.0.1.0/24 table 100 2>/dev/null || true
  '';
};

  systemd.network = {
  enable = true;

};
}
