{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.hyperos.vms.graphics-vm;
  system = "x86_64-linux";
  microvm = inputs.microvm;
  #overlays = import ../../overlays { inherit inputs; };

  # Define the VM configuration
  vmConfiguration = microvm.inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs;
    };
    modules = [
      # Apply microvm's overlay (includes GPU-patched cloud-hypervisor)
      { nixpkgs.overlays = [ microvm.overlays.default ]; }

      # Import microvm's module
      microvm.nixosModules.microvm
      ({ lib, pkgs, config, ... }: {
        microvm = {
          hypervisor = "cloud-hypervisor";
          graphics.enable = true;
          mem = 2048;
          vcpu = 1;  # Set to 1 to avoid multiqueue issues
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

          localCommands = ''
            ${pkgs.iproute2}/bin/ip route add 10.0.0.0/24 via 10.0.1.1 dev eth0
          '';

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
        ];
        hardware.graphics.enable = true;
      })
    ];
  };
in
{
  options.hyperos.vms.graphics-vm = {
    enable = mkEnableOption "graphics VM with cloud-hypervisor";
    # Export the VM configuration so the flake can access it
    vmConfig = mkOption {
      type = types.unspecified;
      internal = true;
      default = vmConfiguration;
      description = "The VM nixosSystem configuration";
    };
  };

  config = mkIf cfg.enable {
    # Pre-create tap interface with proper permissions ai slop
    systemd.services."setup-vm-graphics-tap" = {
      description = "Setup tap device for graphics-vm";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-pre.target" ];
      before = [ "network.target" "systemd-networkd.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      #ai slop auto script
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

    # manually make tap interface:
    #  ip link delete vm-graphics
    #  ip tuntap add dev vm-graphics mode tap user hyper group kvm
    #  ip link set vm-graphics up
    #  ip addr add 10.0.1.1/24 dev vm-graphics

    };

    # Enable systemd-networkd if not already enabled (needed for other VMs)
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
    # Enable IP forwarding on the HOST
    #boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

    # Route graphics-vm through mullvad-vpn-vm
    # FIXED: Split the problematic rule into multiple rules
    networking.firewall.extraCommands = ''
      iptables -A FORWARD -i vm-graphics -o vm-mullvad -j ACCEPT
      iptables -A FORWARD -i vm-mullvad -o vm-graphics -m state --state RELATED,ESTABLISHED -j ACCEPT

      iptables -A INPUT -i vm-graphics -j DROP

      iptables -A FORWARD -i vm-graphics -d 192.168.0.0/16 -j DROP

      iptables -A FORWARD -i vm-graphics -d 10.0.1.0/24 -j ACCEPT
      iptables -A FORWARD -i vm-graphics -d 10.0.0.0/8 -j DROP
    '';
    #old ai slop
    #iptables -A FORWARD -i vm-graphics -d 10.0.0.0/8 ! -d 10.0.1.0/24 -j DROP
  };
}
