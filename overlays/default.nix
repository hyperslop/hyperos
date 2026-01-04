{ inputs }:
{
  # GPU-enabled cloud-hypervisor (from microvm.nix)
  cloud-hypervisor-gpu = import ./cloud-hypervisor-gpu.nix { inherit inputs; };

  # Your custom overlays
 # myCustomOverlay = final: prev: {
 #   # your packages here
 # };
}
