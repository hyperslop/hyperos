# modules/system/vms/test.nix
{ config, pkgs, ... }:

{
  # This is host-level config
  virtualisation.libvirtd.enable = true;

  # Define your VMs under microvm.vms
  microvm.vms.work = {
    autostart = true;

    config = {
      microvm = {
        hypervisor = "cloud-hypervisor";
        vcpu = 2;
        mem = 4096;

        interfaces = [{
          type = "tap";
          id = "vm-work";
          mac = "02:00:00:01:00:01";
        }];

        volumes = [{
          image = "work-vm.img";
          mountPoint = "/";
          size = 20480;
        }];
      };

      networking = {
        hostName = "work-vm";
        firewall.enable = true;
      };

      environment.systemPackages = with pkgs; [
        firefox
        libreoffice
      ];

      services.openssh.enable = true;

      users.users.work = {
        isNormalUser = true;
        password = "changeme";
      };
    };
  };
}
