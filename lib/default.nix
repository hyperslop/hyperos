{ config, lib, options, ... }:
let
  mkBasicOptions = import ./mkBasicOptions.nix { inherit lib; };

  # Only these directories get auto-generated options
  regularModuleDirs = [
    ../modules/system
    ../modules/hardware
    ../modules/profiles
  ];

  # VMs directory - imported but NOT auto-generated
  vmDir = ../modules/vms;

  # Get all .nix files from regular directories
  getAllModuleFiles = directories:
    let
      getFilesFromDir = dir:
        let
          entries = builtins.readDir dir;
          nixFiles = lib.filterAttrs (name: type:
            type == "regular" && lib.hasSuffix ".nix" name
          ) entries;
        in
        lib.mapAttrsToList (filename: _: dir + "/${filename}") nixFiles;
    in
    lib.flatten (map getFilesFromDir directories);

  # Get VM module files separately - these define their own options
  getVmModuleFiles = dir:
    let
      entries = builtins.readDir dir;
      nixFiles = lib.filterAttrs (name: type:
        type == "regular" && lib.hasSuffix ".nix" name
      ) entries;
    in
    lib.mapAttrsToList (filename: _: dir + "/${filename}") nixFiles;

  # Generate config for "all.enable" options (only for regular modules)
  mkAllEnableConfigs = directories:
    let
      processDirectory = dir:
        let
          parentFolder = builtins.baseNameOf dir;
          entries = builtins.readDir dir;
          nixModules = builtins.filter (name: name != null) (
            lib.mapAttrsToList (filename: type:
              if type == "regular" && lib.hasSuffix ".nix" filename
              then lib.removeSuffix ".nix" filename
              else null
            ) entries
          );
          enableAllConfig = lib.mkIf config.hyperos.${parentFolder}.all.enable {
            hyperos.${parentFolder} = lib.genAttrs nixModules (name: {
              enable = lib.mkDefault true;
            });
          };
        in
        enableAllConfig;
    in
    lib.mkMerge (map processDirectory directories);

  # Auto-enable "default" module (only for regular modules)
  mkDefaultAutoEnable = directories:
    let
      processDirectory = dir:
        let
          parentFolder = builtins.baseNameOf dir;
          hasDefaultOption = builtins.tryEval (
            options.hyperos.${parentFolder}.default or null
          );
          optionExists = hasDefaultOption.success && hasDefaultOption.value != null;
          categoryConfig = config.hyperos.${parentFolder} or {};
          allModuleNames = builtins.attrNames categoryConfig;
          regularModules = builtins.filter (name:
            name != "default" && name != "all"
          ) allModuleNames;
          anyModuleEnabled = lib.any (name:
            categoryConfig.${name}.enable or false
          ) regularModules;
          autoEnableConfig = lib.mkIf (optionExists && anyModuleEnabled) {
            hyperos.${parentFolder}.default.enable = lib.mkDefault true;
          };
        in
        autoEnableConfig;
    in
    lib.mkMerge (map processDirectory directories);
in
{
  imports = [
    ./mkProgramOptions.nix
  ] ++ (getAllModuleFiles regularModuleDirs)
    ++ (getVmModuleFiles vmDir);  # VMs imported, they define their own options

  # Generate options ONLY for regular modules (not VMs)
  options = mkBasicOptions.mkBasicOptions regularModuleDirs;

  # Handle "all.enable" options AND auto-enable "default" modules
  # (only for regular module directories, not VMs)
  config = lib.mkMerge [
    (mkAllEnableConfigs regularModuleDirs)
    (mkDefaultAutoEnable regularModuleDirs)
  ];
}
