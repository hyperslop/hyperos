{ inputs }:

let
  lib = inputs.nixpkgs.lib;

  # Get all .nix files in modules/vms/ except default.nix
  vmFiles = builtins.readDir ../modules/vms;
  vmModules = lib.filterAttrs (name: type:
    type == "regular" &&
    lib.hasSuffix ".nix" name &&
    name != "default.nix" &&
    name != "mullvad-vpn-vm.nix"
  ) vmFiles;

  # Import each VM module and extract its vmConfig
  extractVmConfig = vmFile:
    let
      moduleName = lib.removeSuffix ".nix" vmFile;
      # Import the module to get access to its options
      module = import (../modules/vms + "/${vmFile}") {
        inherit inputs;
        config = {}; # Dummy config for extraction
        lib = inputs.nixpkgs.lib;
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      };
      # Get the vmConfig from the module's options
      vmConfig = module.options.hyperos.vms.${moduleName}.vmConfig.default or null;
    in
    if vmConfig != null
    then { ${moduleName} = vmConfig; }
    else {};

  # Collect all VM configurations
  allVms = builtins.foldl' (acc: vmFile:
    acc // (extractVmConfig vmFile)
  ) {} (builtins.attrNames vmModules);
in

allVms
