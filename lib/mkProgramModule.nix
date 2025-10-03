# creates an option: hyperos.programs.example.enable = true/false
# if environment.systemPackages = [ pkgs.example ]; exists, if so it installs. if not, it skips
# when you define it you can add extra nixos configuration with extraConfig {}
# if hasHomeManager = true, sets it to home-manager.sharedModules to /modules/home-manager/example.nix

programName: {
  hasHomeManager ? false,
  extraConfig ? {},
  packageName ? programName
}: { config, lib, pkgs, ... }:
let
  cfg = config.hyperos.programs.${programName};

  # Handle nested packages like "jetbrains.idea-community-bin"
  getPackageIfExists = name:
    if name == null then null
    else lib.attrByPath (lib.splitString "." name) null pkgs;

  package = getPackageIfExists packageName;
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
    (lib.mkIf (package != null) {
      environment.systemPackages = [ package ];
    })

    (lib.mkIf (packageName != null && package == null) {
      warnings = [
        "Package '${packageName}' not found for program '${programName}'"
      ];
    })

    (lib.mkIf (hasHomeManager && cfg.enableHomeManager) {
      home-manager.sharedModules = [ (../modules/home-manager + "/${programName}.nix") ];
    })

    extraConfig
  ]);
}
