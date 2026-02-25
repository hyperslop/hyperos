# Sphinx 9.1.0 sets `disabled = pythonOlder "3.12"` but ceph (via qemu) needs python 3.11.
# Ceph's package.nix calls `python311.override { packageOverrides = ...; }` internally,
# which replaces any packageOverrides we set via overlays.
#
# Workaround: apply the nixpkgs source as a patched path that removes the version gate.
{ inputs, ... }:

final: prev: {
  # Override ceph to disable its rbd/cephfs support in qemu, avoiding the dep entirely.
  # Actually, override qemu to not use ceph.
  qemu = prev.qemu.override {
    cephSupport = false;
  };
  qemu_full = prev.qemu_full.override {
    cephSupport = false;
  };
}
