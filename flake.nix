{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

  outputs = { self, nixpkgs, home-manager, ...}@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {

    homeConfiguration."hyperslop" = home-manager.lib.homeManagerConfiguration { #sets stuff up for home manager
      inherit pkgs;

      extraSpecialArgs = { inherit inputs; };

    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem { #sets stuff up for nixos configuration
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
#  };
#};
}
