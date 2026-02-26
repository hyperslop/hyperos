{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.hyperos.vms.graphics-vm;
  system = "x86_64-linux";
  microvm = inputs.microvm;

  vmConfiguration = microvm.inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      { nixpkgs.overlays = [ microvm.overlays.default ]; }
      microvm.nixosModules.microvm
      ({ lib, pkgs, config, ... }: {
        microvm = {
          hypervisor = "cloud-hypervisor";
          graphics.enable = true;
          mem = 2048;
          vcpu = 1;
          interfaces = [{
            type = "tap";
            id = "vm-graphics";
            mac = "02:00:00:03:03:03";
          }];
        };

        networking = {
          hostName = "graphics-vm";
          useDHCP = false;
          useNetworkd = false;

          interfaces.eth0 = {
            useDHCP = false;
            ipv4.addresses = [{
              address = "10.0.1.2";
              prefixLength = 24;
            }];
          };

          defaultGateway = {
            address = "10.0.1.1";
            interface = "eth0";
          };

          nameservers = [ "10.0.0.2" "1.1.1.1" ];
        };

        system.stateVersion = "24.05";
        services.getty.autologinUser = "user";
        users.users.user = {
          initialPassword = "user";
          group = "user";
          isNormalUser = true;
          extraGroups = [ "wheel" "video" ];
        };
        users.groups.user = {};
        security.sudo = {
          enable = true;
          wheelNeedsPassword = false;
        };

        environment.sessionVariables = {
          WAYLAND_DISPLAY = "wayland-1";
          DISPLAY = ":0";
          QT_QPA_PLATFORM = "wayland";
          GDK_BACKEND = "wayland";
          XDG_SESSION_TYPE = "wayland";
          SDL_VIDEODRIVER = "wayland";
          CLUTTER_BACKEND = "wayland";
        };

        systemd.user.services.wayland-proxy = {
          enable = true;
          description = "Wayland Proxy";
          serviceConfig = {
            ExecStart = "${lib.getExe pkgs.wayland-proxy-virtwl} --virtio-gpu --x-display=0 --xwayland-binary=${lib.getExe pkgs.xwayland}";
            Restart = "on-failure";
            RestartSec = 5;
          };
          wantedBy = [ "default.target" ];
        };

        environment.systemPackages = with pkgs; [
          xdg-utils
          firefox
          curl
          iputils
          tcpdump
          traceroute
          bind
        ];

        hardware.graphics.enable = true;
      })
    ];
  };
in
{
  options.hyperos.vms.graphics-vm = {
    enable = mkEnableOption "graphics VM with cloud-hypervisor";
    vmConfig = mkOption {
      type = types.unspecified;
      internal = true;
      default = vmConfiguration;
      description = "The VM nixosSystem configuration";
    };
  };

  config = mkIf cfg.enable {
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
    };

    networking.iproute2 = {
      enable = true;
      rttablesExtraConfig = ''
        100 graphics-vm
      '';
    };

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

    systemd.services."setup-vm-graphics-tap" = {
      description = "Setup tap device for graphics-vm";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-pre.target" ];
      before = [ "network.target" "systemd-networkd.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        if ${pkgs.iproute2}/bin/ip link show vm-graphics &> /dev/null; then
          ${pkgs.iproute2}/bin/ip link delete vm-graphics || true
        fi

        ${pkgs.iproute2}/bin/ip tuntap add dev vm-graphics mode tap user hyper group kvm
        ${pkgs.iproute2}/bin/ip link set vm-graphics up
        ${pkgs.iproute2}/bin/ip addr add 10.0.1.1/24 dev vm-graphics
      '';

      preStop = ''
        ${pkgs.iproute2}/bin/ip link delete vm-graphics || true
      '';
    };

    systemd.network = {
      enable = true;
      netdevs."21-vm-graphics" = {
        netdevConfig = {
          Name = "vm-graphics";
          Kind = "tap";
        };
        tapConfig = {
          User = "hyper";
          Group = "kvm";
        };
      };
      networks."21-vm-graphics" = {
        matchConfig.Name = "vm-graphics";
        address = [ "10.0.1.1/24" ];
        networkConfig = {
          DHCPServer = "no";
          IPv4Forwarding = "yes";
          IPv6Forwarding = "yes";
        };
        linkConfig.RequiredForOnline = "no";
      };
    };
  };
}
