# 1. Imports _all.nix (single source of truth for programs for hyperos system)
# 2. uses /lib/mkProgramModule.nix logic to create options based on that list
#      ex: hyperos.programs.example.enabled = true/false for each program (default is false)
# 3. The logic here integrates with mkProgramModule and inputs these 3 pieces information:
#      It sends the name "example" to mkProgramModule which checks if a nixpkgs exists, if so it installs. if not, it skips
#      It checks if any file exists at /modules/programs/example.nix, if so it sends it to extraConfig{}
#      It checks if /modules/home-manager/example.nix exists, if so its set to home-manager.sharedModules
# 4. Creates option hyperos.programs.all. This only enables every SOFTWARE with hyperos opinionated configs. not hardware, or system configs
#      See /modules/profiles for more granulare meta-modules ( system, development, desktop, gaming, virtualisation )

{ lib, pkgs, config, ... }:
let
  mk = import ../../lib/mkProgramModule.nix;
  registry = import ./_all.nix;

  # Auto-detect everything for a program
  analyzeProgram = name: {
    inherit name;
    hasPackage = builtins.hasAttr name pkgs;
    hasHomeManager = builtins.pathExists (../home-manager + "/${name}.nix");
    hasExtraConfig = builtins.pathExists (./. + "/${name}.nix");
  };

  # Analyze all programs
  programs = map analyzeProgram registry.all;

  # Generate modules
  modules = map (p: mk p.name {
    packageName = if p.hasPackage then p.name else null;
    hasHomeManager = p.hasHomeManager;
  }) programs;

  # Import extra configs
  extras = builtins.filter (x: x != null)
    (map (p: if p.hasExtraConfig then ./. + "/${p.name}.nix" else null) programs);
in
{
  options.hyperos.programs.all.enable = lib.mkEnableOption "all programs";

  config = lib.mkIf config.hyperos.programs.all.enable {
    # Use mkDefault so individual programs can override
    hyperos.programs = lib.genAttrs registry.all (name: {
      enable = lib.mkDefault true;
    });
  };
  imports = modules ++ extras;
}
