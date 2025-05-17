{ config, pkgs, inputs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      hyperslop = {
      id = 0;
      isDefault = true;
      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [ #adds an extension for a specific browser profile, all profile extensions in sysfirefox.nix
          #ublock-origin
        ];
      };
      school = {
        id = 1;
        isDefault = false;
      };
      work = {
        id = 2;
        isDefault = false;
      };
      misc = {
        id = 3;
        isDefault = false;
      };
      anon = {
        id = 4;
        isDefault = false;
      };
    };
  };
}
