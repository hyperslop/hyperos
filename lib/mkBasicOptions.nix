{ lib }:

with lib;

{
  # Creates enable options for all .nix files in specified directories
  # Returns an attrset like: { hyperos.system.sound.enable = mkEnableOption ...; }
  mkBasicOptions = directories:
    let
      # Process a single directory path
      processDirectory = dir:
        let
          # Get the parent folder name (e.g., "system" from "modules/system")
          parentFolder = baseNameOf dir;

          # Read all entries in the directory
          entries = builtins.readDir dir;

          # Filter for .nix files only
          nixFiles = filterAttrs (name: type:
            type == "regular" && hasSuffix ".nix" name
          ) entries;

          # Create options for each .nix file
          fileOptions = mapAttrs' (filename: _:
            let
              # Remove .nix extension to get the module name
              moduleName = removeSuffix ".nix" filename;
            in
            nameValuePair moduleName {
              enable = mkEnableOption "Enable ${parentFolder}/${moduleName} module";
            }
          ) nixFiles;

          # Add an "all" option to enable everything in this directory
          optionsWithAll = fileOptions // {
            all.enable = mkEnableOption "Enable all ${parentFolder} modules";
          };
        in
        nameValuePair parentFolder optionsWithAll;

      # Process all directories and combine into nested attrset
      allOptions = listToAttrs (map processDirectory directories);
    in
    {
      hyperos = allOptions;
    };

  # Automatically imports modules based on the enabled options
  # Returns a list of module paths that should be imported
  mkAutoImports = config: directories:
    let
      # Process a single directory
      processDirectory = dir:
        let
          parentFolder = baseNameOf dir;
          entries = builtins.readDir dir;

          # Filter for .nix files
          nixFiles = filterAttrs (name: type:
            type == "regular" && hasSuffix ".nix" name
          ) entries;

          # For each .nix file, check if it's enabled and return the path
          enabledModules = mapAttrsToList (filename: _:
            let
              moduleName = removeSuffix ".nix" filename;
              isEnabled = config.hyperos.${parentFolder}.${moduleName}.enable or false;
            in
            optional isEnabled (dir + "/${filename}")
          ) nixFiles;
        in
        flatten enabledModules;

      # Process all directories and flatten the results
      allImports = flatten (map processDirectory directories);
    in
    allImports;
}

