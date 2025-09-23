{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.nixos.virtualisation;
in
{
  options.modules.nixos.virtualisation = {
    enable = mkEnableOption "virtualization with libvirt";

    vms = mkOption {
      type = types.attrsOf types.bool;
      default = {};
      description = "Which VMs to enable";
      example = {
        nixos-dev = true;
        ubuntu-test = true;
        windows-gaming = false;
      };
    };
  };

  config = mkIf cfg.enable {
    # Core virtualization setup
    virtualisation.libvirtd.enable = true;

    # Add all normal users to libvirtd group automatically
    users.groups.libvirtd.members =
      lib.attrNames (lib.filterAttrs (name: user: user.isNormalUser or false) config.users.users);

    # Install virtualization packages
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      libvirt
      qemu
    ];

    # Conditionally import VM files (each VM handles its own disk creation)
    imports = mkMerge [
      (mkIf (cfg.vms.nixos-dev or false) [ ./vms/nixos-dev.nix ])
      (mkIf (cfg.vms.windows11 or false) [ ./vms/windows11.nix ])
      # Add more VMs here
    ];
  };
}
