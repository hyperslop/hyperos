# lib/mkFlatpakModule.nix
programName: appId: { config, lib, ... }:
{
  options.hyperos.programs.${programName}.enable = lib.mkEnableOption programName;

  config = lib.mkIf config.hyperos.programs.${programName}.enable {
    services.flatpak.packages = [
      { inherit appId; origin = "flathub"; }
    ];
  };
}
