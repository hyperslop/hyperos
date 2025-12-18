{ config, lib, ... }:

let
  mkBasicOptions = import ./mkBasicOptions.nix { inherit lib; };

  # Define your module directories here
  moduleDirs = [
    ../modules/system
    ../modules/hardware
    ../modules/profiles
  ];

  # Get all .nix files from all directories (import unconditionally)
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

  # Generate config for "all.enable" options
  mkAllEnableConfigs = directories:
    let
      processDirectory = dir:
        let
          parentFolder = builtins.baseNameOf dir;
          entries = builtins.readDir dir;

          # Get all .nix file names (without extension)
          nixModules = builtins.filter (name: name != null) (
            lib.mapAttrsToList (filename: type:
              if type == "regular" && lib.hasSuffix ".nix" filename
              then lib.removeSuffix ".nix" filename
              else null
            ) entries
          );

          # Create config that enables all modules when parent.all.enable is true
          enableAllConfig = lib.mkIf config.hyperos.${parentFolder}.all.enable {
            hyperos.${parentFolder} = lib.genAttrs nixModules (name: {
              enable = lib.mkDefault true;
            });
          };
        in
        enableAllConfig;
    in
    lib.mkMerge (map processDirectory directories);
in
{
  imports = [
    # Import program management system
    ./mkProgramOptions.nix
  ] ++ (getAllModuleFiles moduleDirs);

  # Generate options for all modules
  options = mkBasicOptions.mkBasicOptions moduleDirs;

  # Handle "all.enable" options
  config = mkAllEnableConfigs moduleDirs;
}
