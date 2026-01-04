{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.hyperos.vms.mullvad-vpn-vm;
  # For testing: put your Mullvad private key directly here
  # SECURITY WARNING: This is for testing only! Never commit this to git!
  mullvadPrivateKey = "PLACEHOLDER";
in
{
  options.hyperos.vms.mullvad-vpn-vm = {
    enable = mkEnableOption "Mullvad VPN gateway VM";
  };

  config = mkIf cfg.enable {
    # Configure the host side of the network
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
          DHCPServer = "no";
          IPv4Forwarding = "yes";
          IPv6Forwarding = "yes";
          IPMasquerade = "both";
        };
      };
    };

    # Enable IP forwarding on host
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };

    # Use microvm.nix's interface directly
    microvm.vms.mullvad-vpn-vm = {
      specialArgs = {
        inherit inputs;
        #something was imported here?
      };
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
        #ssh root@10.0.0.2

        # Use the simpler networking.interfaces approach instead of systemd.network
        networking = {
          hostName = "mullvad-vpn-vm";
          useNetworkd = false;  # Changed to false - use traditional networking
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

          nameservers = [ "100.64.0.3" "1.1.1.1" ];  # Added fallback DNS

          firewall = {
            enable = true;
            trustedInterfaces = [ "wg-mullvad" ];

            extraCommands = ''
              iptables -P INPUT DROP
              iptables -P FORWARD DROP
              iptables -P OUTPUT DROP

              # Loopback
              iptables -A INPUT -i lo -j ACCEPT
              iptables -A OUTPUT -o lo -j ACCEPT

              # CRITICAL: Allow ALL traffic on WireGuard interface FIRST
              iptables -A INPUT -i wg-mullvad -j ACCEPT
              iptables -A OUTPUT -o wg-mullvad -j ACCEPT

              # Established connections (this should catch WireGuard handshake responses)
              iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
              iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
              iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

              # Allow from eth0 (host network) - for SSH and management
              iptables -A INPUT -i eth0 -s 10.0.0.0/24 -j ACCEPT

              # Allow forwarding FROM eth0 (for graphics-vm traffic)
              iptables -A FORWARD -i eth0 -s 10.0.0.0/24 -j ACCEPT
              iptables -A FORWARD -i eth0 -s 10.0.1.0/24 -j ACCEPT

              # Allow DNS out through eth0
              iptables -A OUTPUT -o eth0 -p udp --dport 53 -j ACCEPT
              iptables -A OUTPUT -o eth0 -p tcp --dport 53 -j ACCEPT

              # Allow WireGuard protocol out through eth0
              iptables -A OUTPUT -o eth0 -p udp --dport 51820 -j ACCEPT

              # Allow ICMP for testing
              iptables -A OUTPUT -o eth0 -p icmp -j ACCEPT
              iptables -A INPUT -i eth0 -p icmp -j ACCEPT

              # NAT for forwarded traffic through WireGuard
              iptables -t nat -A POSTROUTING -o wg-mullvad -j MASQUERADE

              # Allow forwarding through WireGuard
              iptables -A FORWARD -o wg-mullvad -j ACCEPT
              iptables -A FORWARD -i wg-mullvad -j ACCEPT
            '';
              # old ai commands, idk?
              #iptables -A FORWARD -s 10.0.1.0/24 -j ACCEPT
              #iptables -A FORWARD -d 10.0.1.0/24 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
              #iptables -A OUTPUT -o wg-mullvad -p udp --dport 53 -j ACCEPT
              #iptables -A OUTPUT -o wg-mullvad -p tcp --dport 53 -j ACCEPT
              #iptables -A OUTPUT -o eth0 -p tcp --dport 53 -j ACCEPT

              #old WORKING commands
              #iptables -P INPUT DROP
              #iptables -P FORWARD DROP
              #iptables -P OUTPUT DROP

              #iptables -A INPUT -i lo -j ACCEPT
              #iptables -A OUTPUT -o lo -j ACCEPT

              #iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
              #iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
              #iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

              #iptables -A INPUT -i eth0 -s 10.0.0.0/24 -j ACCEPT
              #iptables -A FORWARD -i eth0 -s 10.0.0.0/24 -j ACCEPT

              #iptables -A OUTPUT -o eth0 -p udp --dport 53 -j ACCEPT

              #iptables -A OUTPUT -o eth0 -p udp --dport 51820 -j ACCEPT
              #iptables -A OUTPUT -o wg-mullvad -j ACCEPT

              #iptables -t nat -A POSTROUTING -o wg-mullvad -j MASQUERADE
            extraStopCommands = ''
              iptables -P INPUT ACCEPT
              iptables -P FORWARD ACCEPT
              iptables -P OUTPUT ACCEPT
            '';
          };

          wireguard.interfaces.wg-mullvad = {
            ips = [
              "10.68.237.138/32"
              "fc00:bbbb:bbbb:bb01::5:ed89/128"
            ];

            # Direct private key - for testing only!
            privateKey = mullvadPrivateKey;

            peers = [{
              publicKey = "ikLR1TUKk+PTWFnydqwZ9m0HaD1dPaMNI9DwZTvzYBs=";
              endpoint = "23.168.216.127:51820";
              allowedIPs = [ "0.0.0.0/0" "::/0" ];
              persistentKeepalive = 25;
            }];
          };
        };

        # Keep resolved for DNS
        services.resolved = {
          enable = true;
          dnssec = "false";  # Changed to false - can cause issues
          fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
          llmnr = "false";
          extraConfig = ''
            MulticastDNS=no
          '';
        };

        boot.kernel.sysctl = {
          "net.ipv4.ip_forward" = 1;
          "net.ipv6.conf.all.forwarding" = 1;
#          "net.ipv4.conf.all.rp_filter" = 2;
#          "net.ipv4.conf.default.rp_filter" = 2;

#          "net.ipv4.conf.eth0.rp_filter" = 0;  # Add this line

#          "net.ipv4.conf.all.accept_redirects" = 0;
#          "net.ipv4.conf.default.accept_redirects" = 0;
 #         "net.ipv4.conf.all.send_redirects" = 0;
#          "net.ipv4.conf.default.send_redirects" = 0;
#          "net.ipv4.conf.all.accept_source_route" = 0;
#          "net.ipv4.conf.default.accept_source_route" = 0;
        };

        system.stateVersion = "24.05";

        environment.systemPackages = with pkgs; [
          wireguard-tools
          iputils
          tcpdump
          curl
          bind
          jq
        ];
      };
    };
  };
}
