# 1. Imports _all.nix (single source of truth for programs for hyperos system)
# 2. uses /lib/mkProgramModule.nix logic to create options based on that list
#      ex: hyperos.programs.example.enabled = true/false for each program (default is false)
# 3. The logic here integrates with mkProgramModule and inputs these 3 pieces information:
#      It sends the name "example" to mkProgramModule which checks if a nixpkgs exists, if so it installs. if not, it skips
#      It checks if any file exists at /modules/programs/example.nix, if so it sends it to extraConfig{}
#      It checks if /modules/home-manager/example.nix exists, if so its set to home-manager.sharedModules
# 4. Creates option hyperos.programs.all. This only enables every SOFTWARE with hyperos opinionated configs. not hardware, or system configs
#      See /modules/profiles for more granulare meta-modules ( system, development, desktop, gaming, virtualisation )

{ lib, config, ... }:
let
  mk = import ../../lib/mkProgramModule.nix;
  registry = import ./_all.nix;

  # Just check if files exist - no pkgs, no config
  hasHomeManagerFile = name: builtins.pathExists (../home-manager + "/${name}.nix");
  hasExtraConfigFile = name: builtins.pathExists (./. + "/${name}.nix");

  # Simple module generation
  modules = map (name: mk name {
    packageName = name;  # Just pass the name
    hasHomeManager = hasHomeManagerFile name;
  }) registry.all;

  # Import extra config files
  extras = builtins.filter
    (path: path != null)
    (map (name:
      if hasExtraConfigFile name
      then ./. + "/${name}.nix"
      else null
    ) registry.all);
in
{
  options.hyperos.programs.all.enable = lib.mkEnableOption "all programs";

  config = lib.mkIf config.hyperos.programs.all.enable {
    hyperos.programs = lib.genAttrs registry.all (name: {
      enable = lib.mkDefault true;
    });
  };

  imports = modules ++ extras;
}
