{ config, lib, pkgs, ... }:

let
  # You'll need to provide these ISOs yourself
  windows11Iso = "/var/lib/libvirt/images/Win11_23H2_English_x64v2.iso";
  virtioDriversIso = pkgs.fetchurl {
    url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # You'd need the real hash
  };
in
{
  # Create VM disk and setup
  systemd.services."create-vm-disk-windows11" = {
    description = "Create disk for Windows 11 VM";
    before = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      DISK_PATH="/var/lib/libvirt/images/windows11.qcow2"
      VIRTIO_ISO_PATH="/var/lib/libvirt/images/virtio-win.iso"

      # Create disk if it doesn't exist
      if [ ! -f "$DISK_PATH" ]; then
        echo "Creating disk for Windows 11 VM..."
        mkdir -p /var/lib/libvirt/images
        ${pkgs.qemu}/bin/qemu-img create -f qcow2 "$DISK_PATH" 60G
        chown libvirt-qemu:kvm "$DISK_PATH"
        echo "✓ Created Windows 11 disk: $DISK_PATH"
      fi

      # Copy VirtIO drivers
      if [ ! -f "$VIRTIO_ISO_PATH" ]; then
        echo "Copying VirtIO drivers ISO..."
        cp ${virtioDriversIso} "$VIRTIO_ISO_PATH"
        chown libvirt-qemu:kvm "$VIRTIO_ISO_PATH"
        echo "✓ VirtIO drivers ready: $VIRTIO_ISO_PATH"
      fi

      # Check if Windows ISO exists
      if [ ! -f "${windows11Iso}" ]; then
        echo "⚠️  Windows 11 ISO not found at ${windows11Iso}"
        echo "   Please download Windows 11 ISO and place it there"
        echo "   Download from: https://www.microsoft.com/software-download/windows11"
      fi
    '';
  };

  # Windows 11 VM definition
  virtualisation.libvirt.domains.windows11 = {
    definition = ''
      <domain type='kvm'>
        <name>windows11</name>
        <memory unit='MiB'>8192</memory>
        <vcpu placement='static'>4</vcpu>
        <os>
          <type arch='x86_64' machine='pc-q35-6.2'>hvm</type>
          <loader readonly='yes' type='pflash'>/run/libvirt/nix-ovmf/OVMF_CODE.fd</loader>
          <nvram>/var/lib/libvirt/qemu/nvram/windows11_VARS.fd</nvram>
          <boot dev='cdrom'/>
          <boot dev='hd'/>
        </os>
        <features>
          <acpi/>
          <apic/>
          <hyperv>
            <relaxed state='on'/>
            <vapic state='on'/>
            <spinlocks state='on' retries='8191'/>
            <vpindex state='on'/>
            <synic state='on'/>
            <stimer state='on'/>
            <reset state='on'/>
            <vendor_id state='on' value='KVM Hv'/>
            <frequencies state='on'/>
          </hyperv>
          <vmport state='off'/>
        </features>
        <cpu mode='host-passthrough' check='none' migratable='on'>
          <topology sockets='1' dies='1' cores='4' threads='1'/>
        </cpu>
        <clock offset='localtime'>
          <timer name='rtc' tickpolicy='catchup'/>
          <timer name='pit' tickpolicy='delay'/>
          <timer name='hpet' present='no'/>
          <timer name='hypervclock' present='yes'/>
        </clock>
        <devices>
          <emulator>${pkgs.qemu}/bin/qemu-system-x86_64</emulator>

          <!-- Windows 11 ISO -->
          <disk type='file' device='cdrom'>
            <driver name='qemu' type='raw'/>
            <source file='${windows11Iso}'/>
            <target dev='sda' bus='sata'/>
            <readonly/>
          </disk>

          <!-- VirtIO drivers ISO -->
          <disk type='file' device='cdrom'>
            <driver name='qemu' type='raw'/>
            <source file='/var/lib/libvirt/images/virtio-win.iso'/>
            <target dev='sdb' bus='sata'/>
            <readonly/>
          </disk>

          <!-- Main disk -->
          <disk type='file' device='disk'>
            <driver name='qemu' type='qcow2'/>
            <source file='/var/lib/libvirt/images/windows11.qcow2'/>
            <target dev='vda' bus='virtio'/>
          </disk>

          <!-- Network -->
          <interface type='network'>
            <source network='default'/>
            <model type='virtio'/>
          </interface>

          <!-- Graphics -->
          <graphics type='spice' autoport='yes'>
            <listen type='address'/>
            <image compression='off'/>
          </graphics>

          <!-- Video -->
          <video>
            <model type='qxl' ram='65536' vram='65536' vgamem='16384' heads='1' primary='yes'/>
          </video>

          <!-- USB controller for better device support -->
          <controller type='usb' index='0' model='qemu-xhci' ports='15'/>

          <!-- Sound -->
          <sound model='ich9'/>

          <!-- TPM for Windows 11 requirements -->
          <tpm model='tpm-tis'>
            <backend type='emulator' version='2.0'/>
          </tpm>
        </devices>
      </domain>
    '';
  };

  # Helper scripts
  environment.systemPackages = with pkgs; [
    (writeScriptBin "windows11-setup-help" ''
      #!/bin/sh
      cat << 'EOF'
      Windows 11 VM Setup Instructions:

      1. Download Windows 11 ISO:
         https://www.microsoft.com/software-download/windows11
         Place it at: ${windows11Iso}

      2. Start the VM:
         virsh start windows11
         virt-viewer windows11

      3. During Windows installation:
         - When asked for drivers, browse to the VirtIO CD (D: drive)
         - Install storage drivers from viostor/w11/amd64/
         - Install network drivers from NetKVM/w11/amd64/

      4. After Windows installation:
         - Install all VirtIO drivers from the CD
         - Install spice-guest-tools for better integration

      5. Optional: Create a snapshot after setup:
         virsh snapshot-create-as windows11 "fresh-install" "Clean Windows 11 installation"

      VM Requirements met:
      ✓ TPM 2.0 (required for Windows 11)
      ✓ UEFI boot (required for Windows 11)
      ✓ 8GB RAM (recommended for Windows 11)
      ✓ VirtIO drivers (for better performance)
      EOF
    '')

    (writeScriptBin "windows11-post-install" ''
      #!/bin/sh
      echo "Post-installation optimizations for Windows 11 VM..."
      echo ""
      echo "Run these commands in Windows PowerShell (as Administrator):"
      echo ""
      echo "# Disable Windows Defender (for VM performance)"
      echo "Set-MpPreference -DisableRealtimeMonitoring \$true"
      echo ""
      echo "# Disable unnecessary services"
      echo "Set-Service -Name 'DiagTrack' -StartupType Disabled"
      echo "Set-Service -Name 'dmwappushservice' -StartupType Disabled"
      echo ""
      echo "# Enable RDP (optional)"
      echo "Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name 'fDenyTSConnections' -value 0"
      echo "Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'"
    '')
  ];

  # Make sure OVMF is available for UEFI boot (required for Windows 11)
  virtualisation.libvirtd.qemu = {
    ovmf.enable = true;
    ovmf.packages = [ pkgs.OVMFFull.fd ];
  };
}
