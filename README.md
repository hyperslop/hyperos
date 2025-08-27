# HyperOS: My NixOS Configuration
This repository has everything necessary to completely recreate my system, saved in the form of spergalishishly declaritive instructions.


## Understanding the layout

- modules: contains modules for configuration
    - modules/hardware: contains commonly used hardware modules
    - modules/home-manager: contains base user level configuration modules
    - modules/nixos: contains system level configuration modules
- meta: contains meta modules made up of common combinations of home-manager and nixos modules
- hosts: contains configuration for specific hosts, which modules are used on that host
    - hosts/default: the default template host
        - default.nix: host specific settings with system level modules
        - hardware.nix: host specific hardware settings
- users: contains addon configurations for specific modules for specific users
    - users/default: default template user
        - default.nix: non home-manager user specific options, addons, and tweaks
        - home.nix: user specific addons and tweaks for my home-manager modules
- default.nix: the basic configuration with system and use agnostic settings
- flake.nix: sets up a flake for each system, gets external flakes as inputs as needed.
- dotfiles: contains any non declaritive raw text dotfiles


### How does this fit together?

- flake.nix -> imports default.nix -> contains user and host agnostic settings
    - imports a specific hosts files -> contains host specific and user agnostic settings
        - -> imports basic system level modules
        - -> imports specific users -> imports basic user level modules
            - -> imports user specific addons, and tweaks
            

## Features

- home-manager
- flakes
- coherant layout with maximum configurability 
    - basic user and host modules which can easily be picked and chosen, and added onto with host and user specific configuration
- all flatpaks declared in a specific .nix file
- all nixpkgs declared in a specific .nix file
- firefox policies, prefences, and profiles with extension, and extension settings declared
- setup almost every console emulator, older consoles using libretro 


## To do

- declare ublock origin specific tracker lists
- setup davinci resolve
- setup saving secrets that can be unencrypted at runtime
    - setup an ssh key that is declared for git automatically
- setup a declared directory structure in ~/extra for organizing all types of files and to sync with the cloud
    - setup a cloud server with the ability to upload and download files, it will have the same directory structure
    - something like 'cloud-sync (directory)' to upload new files and changed files
    - something like 'cloud-down (directory)' to download files from the cloud to the computer 
    - something like 'cloud-trash (directory)' to delete missing files on the cloud but not on the computer
    
    
## Try HyperOS: It's so good!

1. "find" a computer with nixos installed
2. clone this repository in any spot. I just put it in my home directory.
3. move hardware.nix to hosts/(hostname). To generate use nixos-generate-config
4. Copy the hosts/default/default.nix file to your host, edit it as you choose
5. Copy the user/default/default.nix and home.nix into user/(youruser)/, edit it as you choose
6. In flake.nix, copy the default flake code. Replace the imports with your hosts imports
7. run 'sudo nixos-rebuild switch --flake .#yourcomputer'
