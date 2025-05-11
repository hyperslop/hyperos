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

  };

  outputs = { self, nixpkgs, home-manager, ...}@inputs: {
    # use "nixos", or your hostname as the name of the configuration:
    # it's a better practice than "default" shown in the video
#	let
#    		lib = nixpkgs.lib;
#    		system = "x86_64-linux";
#		pkgs = import nixpkgs { inherit system; };
#    in {
#    homeConfiguration = {
#	hyperslop = home-manager.lib.homeManagerConfiguration {
#	  inherit pkgs;
#	  modules = [ ./home.nix ];
#	};
#	};
#	};
#
#    let
#    	system = "x86_64-linux";
#	pkgs = nixpkgs.legacyPackages.${system};
#    in
 #   {

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
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
