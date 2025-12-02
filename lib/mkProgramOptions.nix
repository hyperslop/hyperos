# Program management system for HyperOS
#
# This module:
# 1. Reads programs.nix as the single source of truth
# 2. Creates hyperos.programs.PROGRAM.enable options for each program
# 3. Automatically installs packages from nixpkgs (default: unstable, overridable)
# 4. Auto-imports configs with priority override system:
#
#    NixOS configs (system-wide):
#      Priority 2 (lowest):  modules/programs/nixos/PROGRAM.nix
#      Priority 1 (highest): hosts/HOST/nixos/PROGRAM.nix
#
#    Home-Manager configs (imported as sharedModules with lib.mkOptionDefault):
#      Priority 3 (lowest):  modules/programs/home-manager/PROGRAM.nix
#      Priority 2:           hosts/HOST/home-manager/PROGRAM.nix
#      Priority 1 (highest): homes/USER/home-manager/PROGRAM.nix (for specified users)
#
# 5. Provides hyperos.programs.all.enable to enable everything at once
# 6. Set hyperos.users = [ "alice" "bob" ] to enable per-user home-manager imports

{ lib, config, pkgs, ... }@args:

let
  # Import the program registry
  registry = import ../modules/programs/programs.nix;

  # Helper to check if a file exists
  fileExists = path: builtins.pathExists path;

  # Helper to get the package source (default/stable/null) default is unstable, unless it got changed randomly
  getPackageSource = programName:
    registry.packageSources.${programName} or "default";

  # Helper to resolve nested package names
  getPackageFromPath = packageName: pkgSet:
    if packageName == null || pkgSet == null then null
    else lib.attrByPath (lib.splitString "." packageName) null pkgSet;

  # Resolve which pkgs to use based on packageSource
  resolvePkgSet = packageSource:
    if packageSource == null then null
    else if packageSource == "default" then pkgs
    else
      # Look for pkgs-stable, pkgs-(commit), etc. in function args
      args.${"pkgs-" + packageSource} or pkgs;

  # Gets hostname from networking.hostName, make a hyperos.host option later?
  hostname =
    if args ? networking && args.networking ? hostName
    then args.networking.hostName
    else "unknown";

  # Gets config location for a specific program
  getConfigPaths = programName: {
    # NixOS configs
    nixos-global = ../modules/programs/nixos + "/${programName}.nix";
    nixos-host = ../hosts + "/${hostname}/nixos/${programName}.nix";

    # Home-Manager configs
    homeManager-global = ../modules/programs/home-manager + "/${programName}.nix";
    homeManager-host = ../hosts + "/${hostname}/home-manager/${programName}.nix";
  };

  # User-specific home-manager config
  getUserHomeManagerPath = programName: username:
    ../homes + "/${username}/home-manager/${programName}.nix";

  # Select which config files to use
  selectConfigFiles = programName:
    let
      paths = getConfigPaths programName;

      # For NixOS configs: host overrides global
      nixosConfig =
        if fileExists paths.nixos-host then paths.nixos-host
        else if fileExists paths.nixos-global then paths.nixos-global
        else null;

      # For home-manager configs: user overrides host overrides global
      # user-specific config will be added later RAAAHHH!!
      baseHomeManagerConfigs = builtins.filter (x: x != null) [
        (if fileExists paths.homeManager-global then paths.homeManager-global else null)
        (if fileExists paths.homeManager-host then paths.homeManager-host else null)
      ];
    in {
      nixos = nixosConfig;
      baseHomeManager = baseHomeManagerConfigs;
      hasBaseHomeManager = baseHomeManagerConfigs != [];
    };

  # WARNING: BOMBOCLAT RECURSION ERROR
  programOptions = lib.listToAttrs (map (programName:
    let configs = selectConfigFiles programName;
    in {
      name = programName;
      value = {
        enable = lib.mkEnableOption programName;
        enableHomeManager = lib.mkOption {
          type = lib.types.bool;
          default = configs.hasBaseHomeManager;
        };
      };
    }
  ) registry.all);

  #-------------------------

  mkProgramConfig = programName:
    let
      cfg = config.hyperos.programs.${programName};
      packageSource = getPackageSource programName;
      pkgSet = resolvePkgSet packageSource;
      package = getPackageFromPath programName pkgSet;
      configs = selectConfigFiles programName;

      # Get user-specific configs for all specified users
      userHomeManagerConfigs =
        map (username: getUserHomeManagerPath programName username)
            config.hyperos.users;

      # Filter to only existing files
      existingUserConfigs = builtins.filter fileExists userHomeManagerConfigs;

      # Combine all home-manager configs: base + user-specific
      # Later configs in the list have higher priority due to how sharedModules works
      allHomeManagerConfigs = configs.baseHomeManager ++ existingUserConfigs;
    in
    lib.mkIf cfg.enable (lib.mkMerge [
      # Install the package if it exists
      (lib.mkIf (packageSource != null && package != null) {
        environment.systemPackages = [ package ];
      })

      # Warn if package not found
      (lib.mkIf (packageSource != null && package == null) {
        warnings = [
          "Package '${programName}' not found in '${packageSource}' package set"
        ];
      })

      # Import home-manager configs if they exist and are enabled
      (lib.mkIf (allHomeManagerConfigs != [] && cfg.enableHomeManager) {
        home-manager.sharedModules = allHomeManagerConfigs;
      })
    ]);

  # Collect all NixOS config files
  nixosConfigModules = builtins.filter
    (path: path != null)
    (map (programName: (selectConfigFiles programName).nixos) registry.all);

in
{
  options.hyperos = {
    programs = programOptions // {
      # Special option to enable all programs at once, move this to some place to do with profiles when you make them
      all.enable = lib.mkEnableOption "all programs in the registry";
    };

    # add the list of users in host file, move this when needed shouldn't be here dont care right now
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  #---------------------------------

  config = lib.mkMerge [
    # When all.enable is true, enable all programs with mkDefault
    (lib.mkIf config.hyperos.programs.all.enable {
      hyperos.programs = lib.genAttrs registry.all (name: {
        enable = lib.mkDefault true;
      });
    })

    # Apply configuration for each enabled program
    (lib.mkMerge (map mkProgramConfig registry.all))
  ];

  # Import all NixOS config files (they contain their own mkIf guards)
  imports = nixosConfigModules;
}
