{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    arkenfox-nixos.url = "github:dwarfmaster/arkenfox-nixos";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

   spectrum-os = {
      url = "git+https://spectrum-os.org/git/nixpkgs";
      flake = false;  # It's not a flake, just a nixpkgs fork
    };

    impermanence.url = "github:nix-community/impermanence";
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
    sops-nix,
    spectrum-os,
    impermanence,
    ...
  }@inputs:
  let
    system = "x86_64-linux";

    # Shared nixpkgs config — applied to all nixpkgs instances
    sharedNixpkgsConfig = {
      allowUnfree = true;
      allowBroken = true;
      permittedInsecurePackages = [
        "electron-36.9.5"
      ];
    };

    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config = sharedNixpkgsConfig;
    };

    overlays = import ./overlays { inherit inputs system; };
    availableVms = import ./lib/mkVms.nix { inherit inputs; };

  in {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [
          {
            nixpkgs.overlays = overlays;
            nixpkgs.config = sharedNixpkgsConfig;
          }
          ./hosts/default/hardware.nix
          ./hosts/default/default.nix
          ./lib
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };

      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [
          {
            nixpkgs.overlays = overlays;
            nixpkgs.config = sharedNixpkgsConfig;
          }
          ./hosts/pc/default.nix
          ./lib
          nix-flatpak.nixosModules.nix-flatpak
          microvm.nixosModules.host
          inputs.sops-nix.nixosModules.sops
          impermanence.nixosModules.impermanence
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [
          {
            nixpkgs.overlays = overlays;
            nixpkgs.config = sharedNixpkgsConfig;
          }
          ./hosts/laptop/default.nix
          ./lib
          nixos-hardware.nixosModules.lenovo-thinkpad-t440p
          nix-flatpak.nixosModules.nix-flatpak
          microvm.nixosModules.host
          impermanence.nixosModules.impermanence
        ];
      };
    } // availableVms;  # Merge in all VMs

    # Create apps for all VMs
   apps.${system} = builtins.mapAttrs (name: vm: {
      type = "app";
      program = "${vm.config.microvm.declaredRunner}/bin/microvm-run";
   }) availableVms;


    devShells.${system} = {

    nodejs = pkgs.mkShell {
    buildInputs = with pkgs; [
      nodejs_22
      nodePackages.npm
      # nodePackages.typescript
      # nodePackages.typescript-language-server
    ];

    shellHook = ''
      echo "Node.js development environment"
      echo "Node: $(node --version)"
      echo "npm: $(npm --version)"
    '';
    };

    python = pkgs.mkShell {
    buildInputs = with pkgs; [
      python3
      python3Packages.pip
      python3Packages.virtualenv
      # Add other Python packages you commonly use:
      # python3Packages.requests
      # python3Packages.numpy
      # python3Packages.pandas
    ];

    shellHook = ''
      echo "Python development environment"
      echo "Python version: $(python --version)"
      echo "pip version: $(pip --version)"

      # Optionally auto-create/activate a virtual environment
      # if [ ! -d .venv ]; then
      #   python -m venv .venv
      # fi
      # source .venv/bin/activate
    '';
    };

    };

  };
}
