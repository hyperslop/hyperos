{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.hyperos.programs.libvirt.enable {
  virtualisation.libvirtd.enable = true;

  virtualisation.libvirtd.qemu = {
    package = pkgs.qemu_kvm;
    swtpm.enable = true;  # TPM emulation support
    #ovmf.enable = true;   # UEFI support for VMs
    };
  };
}
