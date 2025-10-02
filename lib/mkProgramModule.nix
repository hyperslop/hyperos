# creates an option: hyperos.programs.example.enable = true/false
# if environment.systemPackages = [ pkgs.example ]; exists, if so it installs. if not, it skips
# when you define it you can add extra nixos configuration with extraConfig {}
# if hasHomeManager = true, sets it to home-manager.sharedModules to /modules/home-manager/example.nix

programName: {
  hasHomeManager ? false,
  extraConfig ? {},
  packageName ? programName  # Can be overridden or set to null
}: { config, lib, pkgs, ... }:
{
  options.hyperos.programs.${programName}.enable = lib.mkEnableOption programName;

  config = lib.mkIf config.hyperos.programs.${programName}.enable (lib.mkMerge [
    # Base config - only if packageName is not null
    (lib.mkIf (packageName != null) {
      environment.systemPackages = [ (lib.getAttr packageName pkgs) ];
    })

    # Home manager module - only if hasHomeManager is true
    (lib.mkIf hasHomeManager {
      home-manager.sharedModules = [ (../home-manager + "/${programName}.nix") ];
    })

    # Extra custom config
    extraConfig
  ]);
}
