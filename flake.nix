{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    hyprland = {
	url = "github:hyprwm/Hyprland";
	inputs.nixpkgs.follows = "nixpkgs";
    };

    #hyprland-plugins = {
    #  url = "github:hyprwm/hyprland-plugins";
    #  inputs.hyprland.follows = "hyprland";
    #};

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, nix-flatpak, ...}@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {

    homeConfiguration."hyper" = home-manager.lib.homeManagerConfiguration { #idk what this does
      inherit pkgs;

      extraSpecialArgs = { inherit inputs; };

    };
    nixosConfigurations.default = nixpkgs.lib.nixosSystem { #default machine
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/default/hardware.nix
        ./hosts/default/default.nix
        ./default.nix
        inputs.home-manager.nixosModules.default
      ];
    };

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem { #setup for my desktop computer
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/hyper-desktop/hardware.nix
        ./hosts/hyper-desktop/default.nix
        ./default.nix
        nix-flatpak.nixosModules.nix-flatpak
        inputs.home-manager.nixosModules.default
      ];
    };
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem { #setup for my laptop computer
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/hyper-laptop/hardware.nix
        ./hosts/hyper-laptop/default.nix
        ./default.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-t440p
        nix-flatpak.nixosModules.nix-flatpak
        inputs.home-manager.nixosModules.default
      ];
    };
  };
#  };
#};
}
