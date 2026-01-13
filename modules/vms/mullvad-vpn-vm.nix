{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.hyperos.vms.mullvad-vpn-vm;
  mullvadPrivateKey = "PLACEHOLDER";
in
{
  options.hyperos.vms.mullvad-vpn-vm = {
    enable = mkEnableOption "Mullvad VPN gateway VM";
  };

  config = mkIf cfg.enable {
    # Host network configuration
    systemd.network = {
      enable = true;

      netdevs."20-vm-mullvad" = {
        netdevConfig = {
          Name = "vm-mullvad";
          Kind = "tap";
        };
      };

      networks."20-vm-mullvad" = {
        matchConfig.Name = "vm-mullvad";
        address = [ "10.0.0.1/24" ];
        networkConfig = {
          DHCPServer = false;
          IPv4Forwarding = true;
          IPv6Forwarding = true;
          IPMasquerade = "both";
        };

        # Routes for table 100
        routes = [
          {
            Gateway = "10.0.0.2";
            Table = 100;
          }
          {
            Destination = "10.0.0.0/24";
            Table = 100;
          }
        ];
      };
    };

    # Enable IP forwarding on host

    microvm.vms.mullvad-vpn-vm = {
      specialArgs = { inherit inputs; };
      autostart = true;

      config = { config, ... }: {
        microvm = {
          hypervisor = "cloud-hypervisor";
          graphics.enable = false;
          mem = 512;
          vcpu = 1;

          interfaces = [{
            type = "tap";
            id = "vm-mullvad";
            mac = "02:00:00:02:02:02";
          }];
        };

        services.openssh = {
          enable = true;
          settings.PermitRootLogin = "yes";
          settings.PermitEmptyPasswords = "yes";
        };

        users.users.root.password = "root";

        networking = {
          hostName = "mullvad-vpn-vm";
          useNetworkd = false;
          useDHCP = false;

          interfaces.eth0 = {
            useDHCP = false;
            ipv4.addresses = [{
              address = "10.0.0.2";
              prefixLength = 24;
            }];
          };

          defaultGateway = {
            address = "10.0.0.1";
            interface = "eth0";
          };

          # CRITICAL: Route WireGuard endpoint through eth0, not the tunnel
          localCommands = ''
            # Add route for WireGuard endpoint through physical gateway
            ${pkgs.iproute2}/bin/ip route add 23.168.216.127 via 10.0.0.1 dev eth0

            # Now set default route through WireGuard
            ${pkgs.iproute2}/bin/ip route del default || true
            ${pkgs.iproute2}/bin/ip route add default dev wg-mullvad
          '';

          # Don't set nameservers here - let resolved handle it
          # nameservers = [ "1.1.1.1" "8.8.8.8" ];

          firewall = {
            enable = true;
            trustedInterfaces = [ "wg-mullvad" "eth0" ];

            extraCommands = ''
              # Accept from trusted interfaces
              iptables -A INPUT -i lo -j ACCEPT
              iptables -A INPUT -i eth0 -j ACCEPT
              iptables -A INPUT -i wg-mullvad -j ACCEPT

              # Forward traffic from graphics-vm (via host NAT) through VPN
              iptables -A FORWARD -i eth0 -o wg-mullvad -j ACCEPT
              iptables -A FORWARD -i wg-mullvad -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT

              # NAT all outgoing traffic through WireGuard
              iptables -t nat -A POSTROUTING -o wg-mullvad -j MASQUERADE
            '';
          };

          wireguard.interfaces.wg-mullvad = {
            ips = [
              "10.68.237.138/32"
              "fc00:bbbb:bbbb:bb01::5:ed89/128"
            ];

            privateKey = mullvadPrivateKey;

            # Set MTU to avoid fragmentation issues in VM
            mtu = 1420;

            peers = [{
              publicKey = "ikLR1TUKk+PTWFnydqwZ9m0HaD1dPaMNI9DwZTvzYBs=";
              endpoint = "23.168.216.127:51820";
              allowedIPs = [ "0.0.0.0/0" "::/0" ];
              persistentKeepalive = 25;
            }];
          };
        };

        services.resolved = {
          enable = true;
          dnssec = "false";
          fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
        };

        boot.kernel.sysctl = {
          "net.ipv4.ip_forward" = 1;
          "net.ipv6.conf.all.forwarding" = 1;
        };

        system.stateVersion = "24.05";

        environment.systemPackages = with pkgs; [
          wireguard-tools
          iputils
          tcpdump
          curl
          bind
          jq
          iptables
        ];
      };
    };
  };
}
