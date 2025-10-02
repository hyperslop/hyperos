# 1. Imports _all.nix (list of all programs for my system)
# 2. uses mkProgramModule logic to create options based on that list
#      ex: hyperos.programs.example.enabled = true/false for each program
# 3. The logic here iterates through _all.nix with each item being run through /lib/mkProgramModule.nix
#      It checks if environment.systemPackages = [ pkgs.example ]; exists, if so it installs. if not, it skips
#      It checks if any nixos config exists at /hyperos/modules/programs/example.nix, if so its added to extraConfig{}
#      It checks if hyperos/modules/home-manager/example.nix exists, if so its set to home-manager.sharedModules

{ lib, pkgs, ... }:
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
  imports = modules ++ extras;
}
