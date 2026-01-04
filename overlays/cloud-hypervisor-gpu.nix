{ inputs }:

final: prev: {
  # Import SpectrumOS's GPU-patched cloud-hypervisor
  cloud-hypervisor-graphics =
    let
      spectrumPkgs = import inputs.spectrum-os {
        system = final.system;
        config = final.config;
      };
    in
    spectrumPkgs.cloud-hypervisor or prev.cloud-hypervisor;

  # Also provide as regular cloud-hypervisor for compatibility
  cloud-hypervisor =
    let
      spectrumPkgs = import inputs.spectrum-os {
        system = final.system;
        config = final.config;
      };
    in
    spectrumPkgs.cloud-hypervisor or prev.cloud-hypervisor;
}
