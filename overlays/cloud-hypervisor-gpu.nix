{ inputs, ... }:
final: prev: {
  cloud-hypervisor-graphics =
    let
      spectrumPkgs = import inputs.spectrum-os {
        system = final.system;
        config = { allowUnfree = true; };
      };
    in
    spectrumPkgs.cloud-hypervisor or prev.cloud-hypervisor;

  cloud-hypervisor =
    let
      spectrumPkgs = import inputs.spectrum-os {
        system = final.system;
        config = { allowUnfree = true; };
      };
    in
    spectrumPkgs.cloud-hypervisor or prev.cloud-hypervisor;
}
