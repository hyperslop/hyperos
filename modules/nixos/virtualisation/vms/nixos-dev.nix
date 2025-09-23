{ config, lib, pkgs, ... }:

{
  # Define the VM
  virtualisation.libvirt.domains.nixos-dev = {
    definition = ''
      <domain type='kvm'>
        <name>nixos-dev</name>
        <memory unit='MiB'>2048</memory>
        <vcpu placement='static'>1</vcpu>
        <os>
          <type arch='x86_64' machine='pc'>hvm</type>
          <boot dev='hd'/>
        </os>
        <devices>
          <emulator>${pkgs.qemu}/bin/qemu-system-x86_64</emulator>
          <disk type='file' device='disk'>
            <driver name='qemu' type='qcow2'/>
            <source file='/var/lib/libvirt/images/nixos-dev.qcow2'/>
            <target dev='vda' bus='virtio'/>
          </disk>
          <!-- Use default network = automatic internet -->
          <interface type='network'>
            <source network='default'/>
            <model type='virtio'/>
          </interface>
          <graphics type='spice' autoport='yes'/>
          <video>
            <model type='qxl'/>
          </video>
        </devices>
      </domain>
    '';
  };

  # Automatically create the disk for this VM
  systemd.services."create-vm-disk-nixos-dev" = {
    description = "Create disk for nixos-dev VM";
    before = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      DISK_PATH="/var/lib/libvirt/images/nixos-dev.qcow2"
      if [ ! -f "$DISK_PATH" ]; then
        echo "Creating disk for nixos-dev VM..."
        mkdir -p /var/lib/libvirt/images
        ${pkgs.qemu}/bin/qemu-img create -f qcow2 "$DISK_PATH" 20G
        chown libvirt-qemu:kvm "$DISK_PATH"
        echo "✓ Created VM disk: $DISK_PATH"
      else
        echo "✓ VM disk already exists: $DISK_PATH"
      fi
    '';
  };
}
