# creates an option: hyperos.programs.example.enable = true/false
# if environment.systemPackages = [ pkgs.example ]; exists, if so it installs. if not, it skips
# when you define it you can add extra nixos configuration with extraConfig {}
# if hasHomeManager = true, sets it to home-manager.sharedModules to /modules/home-manager/example.nix

programName: {
  hasHomeManager ? false,
  extraConfig ? {},
  packageName ? programName,
  packageSource ? "default"
}: { config, lib, pkgs, ... }@args:  # Capture all args here
let
  cfg = config.hyperos.programs.${programName};

  # Select the appropriate package set based on packageSource
  pkgSet =
    if packageSource == null then null
    else if packageSource == "default" then pkgs
    else
      # Look directly in the function arguments, not config._module.args
      let customPkgs = args.${"pkgs-" + packageSource} or null;
      in if customPkgs != null then customPkgs else pkgs;

  # Handle nested packages like "jetbrains.idea-community-bin"
  getPackageIfExists = name: pkgSet:
    if name == null || pkgSet == null then null
    else lib.attrByPath (lib.splitString "." name) null pkgSet;

  package = getPackageIfExists packageName pkgSet;
in
{
  options.hyperos.programs.${programName} = {
    enable = lib.mkEnableOption programName;
    enableHomeManager = lib.mkOption {
      type = lib.types.bool;
      default = hasHomeManager;
      description = "Whether to import home-manager configuration for ${programName}";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # Only install package if packageSource is not null and package exists
    (lib.mkIf (packageSource != null && package != null) {
      environment.systemPackages = [ package ];
    })

    # Warning if package not found (but only if we're trying to install it)
    (lib.mkIf (packageSource != null && packageName != null && package == null) {
      warnings = [
        "Package '${packageName}' not found in ${packageSource} package set for program '${programName}'"
      ];
    })

    (lib.mkIf (hasHomeManager && cfg.enableHomeManager) {
      home-manager.sharedModules = [ (../modules/home-manager + "/${programName}.nix") ];
    })

    extraConfig
  ]);
}
