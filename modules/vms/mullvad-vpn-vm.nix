{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.hyperos.vms.mullvad-vpn-vm;
in
{
  options.hyperos.vms.mullvad-vpn-vm = {
    enable = mkEnableOption "Mullvad VPN gateway VM";
  };

  config = mkIf cfg.enable {

    # Decrypt the secret on the HOST
    sops = {
      defaultSopsFile = ../../secrets/mullvad/secrets.yaml; # adjust path to your secrets file
      age.keyFile = "/var/lib/sops-nix/key.txt"; # or wherever your age key lives

      secrets."mullvad-private-key" = {
        # This will decrypt to /run/secrets/mullvad-private-key on the host
      };
    };

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

          shares = [{
            tag = "secrets";
            source = "/run/secrets";  # host path where sops decrypts
            mountPoint = "/secrets";
            proto = "virtiofs";
          }];
        };

        # ... rest of VM config stays the same, but change the WireGuard key:

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

          localCommands = ''
            ${pkgs.iproute2}/bin/ip route add 23.168.216.127 via 10.0.0.1 dev eth0
            ${pkgs.iproute2}/bin/ip route del default || true
            ${pkgs.iproute2}/bin/ip route add default dev wg-mullvad
          '';

          firewall = {
            enable = true;
            trustedInterfaces = [ "wg-mullvad" "eth0" ];
            extraCommands = ''
              iptables -A INPUT -i lo -j ACCEPT
              iptables -A INPUT -i eth0 -j ACCEPT
              iptables -A INPUT -i wg-mullvad -j ACCEPT
              iptables -A FORWARD -i eth0 -o wg-mullvad -j ACCEPT
              iptables -A FORWARD -i wg-mullvad -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
              iptables -t nat -A POSTROUTING -o wg-mullvad -j MASQUERADE
            '';
          };

          wireguard.interfaces.wg-mullvad = {
            ips = [
              "10.68.237.138/32"
              "fc00:bbbb:bbbb:bb01::5:ed89/128"
            ];

            # Read the key from the shared mount at runtime
            privateKeyFile = "/secrets/mullvad-private-key";

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

        services.openssh = {
          enable = true;
          settings.PermitRootLogin = "yes";
          settings.PermitEmptyPasswords = "yes";
        };

        users.users.root.password = "root";

        boot.kernel.sysctl = {
          "net.ipv4.ip_forward" = 1;
          "net.ipv6.conf.all.forwarding" = 1;
        };

        system.stateVersion = "24.05";

        environment.systemPackages = with pkgs; [
          wireguard-tools iputils tcpdump curl bind jq iptables
        ];
      };
    };
  };
}
