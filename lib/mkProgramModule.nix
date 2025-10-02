# creates an option: hyperos.programs.example.enable = true/false
# if environment.systemPackages = [ pkgs.example ]; exists, if so it installs. if not, it skips
# when you define it you can add extra nixos configuration with extraConfig {}
# if hasHomeManager = true, sets it to home-manager.sharedModules to /modules/home-manager/example.nix

programName: {
  hasHomeManager ? false,
  extraConfig ? {},
  packageName ? programName
}: { config, lib, pkgs, ... }:
{
  options.hyperos.programs.${programName} = {
    enable = lib.mkEnableOption programName;

    # NEW: Control home-manager separately
    enableHomeManager = lib.mkOption {
      type = lib.types.bool;
      default = hasHomeManager;  # Default based on whether HM file exists
      description = "Whether to import home-manager configuration for ${programName}";
    };
  };

  config = lib.mkIf config.hyperos.programs.${programName}.enable (lib.mkMerge [
    # Base config - only install package if packageName is provided
    (lib.optionalAttrs (packageName != null) {
      environment.systemPackages = [ (lib.getAttr packageName pkgs) ];
    })

    # Home manager module - only if both hasHomeManager AND enableHomeManager are true
    (lib.mkIf (hasHomeManager && config.hyperos.programs.${programName}.enableHomeManager) {
      home-manager.sharedModules = [ (../home-manager + "/${programName}.nix") ];
    })

    # Extra custom config
    extraConfig
  ]);
}
