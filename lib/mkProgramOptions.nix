# Program management system for HyperOS
#
# This module:
# 1. Reads programs.nix as the single source of truth
# 2. Creates hyperos.programs.PROGRAM.enable options for each program
# 3. Automatically installs packages from nixpkgs (default: unstable, overridable)
# 4. Auto-imports configs with multi-tier stacking and override support:
#
#    NixOS configs (system-wide):
#      Tier 1 (lowest):  modules/programs/nixos/PROGRAM.nix
#      Tier 2:           hosts/HOST/nixos/PROGRAM[.override].nix
#      Tier 3 (highest): homes/USER/nixos/PROGRAM[.override].nix
#
#    Home-Manager configs (imported as sharedModules):
#      Tier 1 (lowest):  modules/programs/home-manager/PROGRAM.nix
#      Tier 2:           hosts/HOST/home-manager/PROGRAM[.override].nix
#      Tier 3 (highest): homes/USER/home-manager/PROGRAM[.override].nix
#
#    Naming convention:
#      PROGRAM.nix          → merged with all lower-priority configs (default)
#      PROGRAM.override.nix → replaces all lower-priority configs (those are not imported)
#
# 5. Provides hyperos.programs.all.enable to enable everything at once
# 6. hostname is passed via specialArgs from flake.nix (e.g. hostname = "pc")

{ lib, config, pkgs, hostname ? "default", ... }@args:

let
  helpers = import ./mkOverrideHelpers.nix { inherit lib; };
  inherit (helpers) resolveFile resolveFiles;

  # Import the program registry
  registry = import ../modules/programs/programs.nix;

  # Static scan of homes/ directory — used for both NixOS and HM user configs.
  # Evaluated at import time so it can be used in the `imports` list.
  homeUsers =
    if builtins.pathExists ../homes
    then builtins.attrNames (lib.filterAttrs (_: v: v == "directory") (builtins.readDir ../homes))
    else [];

  # ---------------------------------------------------------------------------
  # Package helpers (unchanged from original)
  # ---------------------------------------------------------------------------

  getPackageSource = programName:
    registry.packageSources.${programName} or "default";

  getPackageFromPath = packageName: pkgSet:
    if packageName == null || pkgSet == null then null
    else lib.attrByPath (lib.splitString "." packageName) null pkgSet;

  resolvePkgSet = packageSource:
    if packageSource == null then null
    else if packageSource == "flatpak" then null
    else if packageSource == "default" then pkgs
    else args.${"pkgs-" + packageSource} or pkgs;

  # ---------------------------------------------------------------------------
  # Multi-tier config file resolution
  # ---------------------------------------------------------------------------

  # Returns the resolved nixos and home-manager file lists for a program,
  # with override logic applied across all tiers.
  selectConfigFiles = programName:
    let
      # NixOS entries ordered lowest → highest priority
      nixosEntries =
        [ (resolveFile (../modules/programs/nixos + "/${programName}.nix"))
          (resolveFile (../hosts + "/${hostname}/nixos/${programName}.nix"))
        ] ++ (map (user:
          resolveFile (../homes + "/${user}/nixos/${programName}.nix")
        ) homeUsers);

      # Home-Manager entries ordered lowest → highest priority
      hmEntries =
        [ (resolveFile (../modules/programs/home-manager + "/${programName}.nix"))
          (resolveFile (../hosts + "/${hostname}/home-manager/${programName}.nix"))
        ] ++ (map (user:
          resolveFile (../homes + "/${user}/home-manager/${programName}.nix")
        ) homeUsers);

      nixosFiles = resolveFiles nixosEntries;
      hmFiles    = resolveFiles hmEntries;
    in {
      nixos              = nixosFiles;
      homeManager        = hmFiles;
      hasBaseHomeManager = hmFiles != [];
    };

  # ---------------------------------------------------------------------------
  # Option definitions
  # ---------------------------------------------------------------------------

  # WARNING: BOMBOCLAT RECURSION ERROR (keep comment — it's load-bearing)
  programOptions = lib.listToAttrs (map (programName:
    let configs = selectConfigFiles programName;
    in {
      name = programName;
      value = {
        enable = lib.mkEnableOption programName;
        enableHomeManager = lib.mkOption {
          type    = lib.types.bool;
          default = configs.hasBaseHomeManager;
        };
      };
    }
  ) registry.all);

  # ---------------------------------------------------------------------------
  # Per-program config application
  # ---------------------------------------------------------------------------

  mkProgramConfig = programName:
    let
      cfg           = config.hyperos.programs.${programName};
      packageSource = getPackageSource programName;
      pkgSet        = resolvePkgSet packageSource;
      package       = getPackageFromPath programName pkgSet;
      configs       = selectConfigFiles programName;
    in
    lib.mkIf cfg.enable (lib.mkMerge [
      # Install the package if it exists in the resolved pkg set
      (lib.mkIf (packageSource != null && package != null) {
        environment.systemPackages = [ package ];
      })

      # Warn if the package name isn't found in the chosen pkg set
      (lib.mkIf (packageSource != null && package == null) {
        warnings = [
          "Package '${programName}' not found in '${packageSource}' package set"
        ];
      })

      # Import ALL resolved home-manager configs (stacked; lower tiers use lib.mkDefault)
      (lib.mkIf (configs.homeManager != [] && cfg.enableHomeManager) {
        home-manager.sharedModules = configs.homeManager;
      })
    ]);

  # Collect all NixOS config files across all tiers for all programs.
  # Files self-guard with lib.mkIf config.hyperos.programs.PROG.enable.
  nixosConfigModules =
    lib.flatten (map (programName: (selectConfigFiles programName).nixos) registry.all);

in
{
  options.hyperos = {
    programs = programOptions // {
      all.enable = lib.mkEnableOption "all programs in the registry";
    };

    users = lib.mkOption {
      type    = lib.types.listOf lib.types.str;
      default = [];
    };
  };

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

  # Import all resolved NixOS config files (they contain their own mkIf guards)
  imports = nixosConfigModules;
}
