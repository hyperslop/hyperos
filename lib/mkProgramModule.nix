# lib/mkProgramModule.nix
{ lib, ... }:

{
  # Creates a basic program module that installs a package and optionally adds home-manager config
  # Usage: mkProgramModule "git" { }
  # Or with home-manager file: mkProgramModule "git" { hasHomeManager = true; }
  # Or with inline config: mkProgramModule "git" { extraOptions = {...}; extraConfig = {...}; extraHomeConfig = {...}; }
  mkProgramModule = programName: {
    extraOptions ? {},
    extraConfig ? {},
    extraHomeConfig ? {},
    packageName ? programName,  # Allows overriding the package name if different from program name
    hasHomeManager ? false,      # If true, imports hyperos/modules/home-manager/${programName}.nix
    homeManagerPath ? null       # Override the home-manager file path if needed
  }: { config, lib, pkgs, ... }:

  let
    cfg = config.hyperos.programs.${programName};

    # Determine the home-manager module path
    hmPath = if homeManagerPath != null
             then homeManagerPath
             else ../home-manager + "/${programName}.nix";

    # Import home-manager module if it exists and hasHomeManager is true
    hmModule = if hasHomeManager && builtins.pathExists hmPath
               then import hmPath
               else { };
  in
  {
    options.hyperos.programs.${programName} = {
      enable = lib.mkEnableOption "Enable ${programName}";
    } // extraOptions;  # Merge in any extra options

    config = lib.mkIf cfg.enable (lib.mkMerge [
      # Base configuration - always applied
      {
        environment.systemPackages = [ pkgs.${packageName} ];
      }

      # Extra system-level config
      extraConfig

      # Home-manager configuration if home-manager is enabled
      (lib.mkIf config.hyperos.core.home-manager.enable {
        home-manager.users.${config.hyperos.core.home-manager.username} = lib.mkMerge [
          # Default: just enable the program
          {
            programs.${programName}.enable = true;
          }
          # Import external home-manager module if specified
          (lib.mkIf hasHomeManager hmModule)
          # Inline extra home-manager config
          extraHomeConfig
        ];
      })
    ]);
  };
}
