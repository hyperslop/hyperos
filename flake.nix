{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    arkenfox-nixos.url = "github:dwarfmaster/arkenfox-nixos";

    hyprland = {
	url = "github:hyprwm/Hyprland";
	inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
  self,
  nixpkgs,
  nixpkgs-stable,
  home-manager,
  nixos-hardware,
  nix-flatpak,
  arkenfox-nixos,
  plasma-manager,
  microvm,
  ...
  }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem { #default machine
      specialArgs = {
        inherit inputs;
        inherit pkgs-stable;
      };
      modules = [
        ./hosts/default/hardware.nix
        ./hosts/default/default.nix
        nix-flatpak.nixosModules.nix-flatpak
      ];
    };

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem { #setup for my desktop computer
      specialArgs = {
        inherit inputs;
        inherit pkgs-stable;
      };
      modules = [
        ./hosts/pc/default.nix
        nix-flatpak.nixosModules.nix-flatpak
        microvm.nixosModules.host

        #test vm
        #./modules/system/vms/test.nix
      ];
    };
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem { #setup for my laptop computer
      specialArgs = {
        inherit inputs;
        inherit pkgs-stable;
      };
      modules = [
        ./hosts/laptop/default.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-t440p
        nix-flatpak.nixosModules.nix-flatpak
      ];
    };
  };
}
