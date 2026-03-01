{ config, lib, options, hostname ? "default", ... }:
let
  mkBasicOptions = import ./mkBasicOptions.nix { inherit lib; };
  helpers        = import ./mkOverrideHelpers.nix { inherit lib; };
  inherit (helpers) resolveFile resolveFiles;

  # Only these directories get auto-generated options
  regularModuleDirs = [
    ../modules/system
    ../modules/hardware
    ../modules/profiles
  ];

  # VMs directory - imported but NOT auto-generated
  vmDir = ../modules/vms;

  # Static scan of homes/ for user-level module overrides
  homeUsers =
    if builtins.pathExists ../homes
    then builtins.attrNames (lib.filterAttrs (_: v: v == "directory") (builtins.readDir ../homes))
    else [];

  # ---------------------------------------------------------------------------
  # Override-aware module file collection
  #
  # For each category directory (system, hardware, profiles):
  #   1. Gather the union of module names found across global, host, and user dirs
  #   2. For each module name, build [global, host, user...] entry list
  #   3. Apply override logic (a .override.nix drops all lower-priority files)
  #   4. Return the flat list of paths to import
  # ---------------------------------------------------------------------------

  # Extract the base module name (strip .nix or .override.nix suffix)
  moduleBaseName = filename:
    if lib.hasSuffix ".override.nix" filename
    then lib.removeSuffix ".override.nix" filename
    else lib.removeSuffix ".nix" filename;

  # Get all unique base module names from a directory (skipping non-.nix files)
  moduleNamesFromDir = dir:
    if builtins.pathExists dir
    then
      lib.unique (builtins.filter (n: n != null) (
        lib.mapAttrsToList (name: type:
          if type == "regular" && lib.hasSuffix ".nix" name
          then moduleBaseName name
          else null
        ) (builtins.readDir dir)
      ))
    else [];

  getAllModuleFilesWithOverrides = directories:
    let
      processDir = dir:
        let
          category = builtins.baseNameOf dir;
          hostDir  = ../hosts + "/${hostname}/${category}";

          globalNames = moduleNamesFromDir dir;
          hostNames   = moduleNamesFromDir hostDir;
          userNames   = lib.flatten (map (user:
            moduleNamesFromDir (../homes + "/${user}/${category}")
          ) homeUsers);

          allNames = lib.unique (globalNames ++ hostNames ++ userNames);

          processModule = modName:
            let
              globalEntry = resolveFile (dir + "/${modName}.nix");
              hostEntry   = resolveFile (hostDir + "/${modName}.nix");
              userEntries = map (user:
                resolveFile (../homes + "/${user}/${category}/${modName}.nix")
              ) homeUsers;
            in
            resolveFiles ([ globalEntry hostEntry ] ++ userEntries);
        in
        lib.flatten (map processModule allNames);
    in
    lib.flatten (map processDir directories);

  # Get VM module files separately - these define their own options
  getVmModuleFiles = dir:
    let
      entries  = builtins.readDir dir;
      nixFiles = lib.filterAttrs (name: type:
        type == "regular" && lib.hasSuffix ".nix" name
      ) entries;
    in
    lib.mapAttrsToList (filename: _: dir + "/${filename}") nixFiles;

  # ---------------------------------------------------------------------------
  # "all.enable" and auto-enable helpers (unchanged, operate on global dirs)
  # ---------------------------------------------------------------------------

  mkAllEnableConfigs = directories:
    let
      processDirectory = dir:
        let
          parentFolder = builtins.baseNameOf dir;
          entries      = builtins.readDir dir;
          nixModules   = builtins.filter (name: name != null) (
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

  mkDefaultAutoEnable = directories:
    let
      processDirectory = dir:
        let
          parentFolder  = builtins.baseNameOf dir;
          hasDefaultOption = builtins.tryEval (
            options.hyperos.${parentFolder}.default or null
          );
          optionExists    = hasDefaultOption.success && hasDefaultOption.value != null;
          categoryConfig  = config.hyperos.${parentFolder} or {};
          allModuleNames  = builtins.attrNames categoryConfig;
          regularModules  = builtins.filter (name:
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
  ] ++ (getAllModuleFilesWithOverrides regularModuleDirs)
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
