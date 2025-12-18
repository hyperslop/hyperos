# HyperOS: The Better NixOS Configuration

### 🗣️🗣️🗣️ Everything entirely necessary for the overtly sane desktop experience 🗣️🗣️🗣️

## Features:

+ modular system structure
  + easily make new hosts and users configurations specific and seperate
+ granular control, use and automatically create toggle options for easy system/user definiton
  + easy preconfigured profiles with many applications configured for common uses
  + custom program options that seemlessly combine user and system level configuration
  + single source of truth for all programs configured for hyperos
  
## Working On:
+ custom easy, fast, and secure fully declared virtual machines
  + toggle easy vm templates for specific uses
  + include options in vm definitions, the same as normal hosts
  + easy options for common vm specific requirements
  
## Future Plans:
+ store dynamic files for specific programs in an easy way, transfer between machines automatically
  + browser bookmarks
  + freetube subscriptions
  + video game saves
    + store this in a place that gets pulled and pushed from and is setup by system automatically? no need for version control.
+ easy encryption and integration for sensative data required for configuration

    
## Try HyperOS: It's so good!

1. "find" a computer with nixos installed
2. clone this repository to any spot
4. Copy the hosts/default/default.nix file to your host, edit it as you choose
    -options like `hyperos.profiles.desktop.enabled = true` or `hyperos.programs.steam.enabled = true` with my objectivly correct configs
5. Copy the homes/default/default.nix and home.nix into homes/(youruser)/, edit it as you choose
6. In flake.nix make a machine for yourself
7. `sudo nixos-rebuild switch --flake .#hostname`

## The Layout Explained
```
flake.nix

homes/
    user1/
        default.nix #defines the user
        home.nix #defines the user home-manager configuration
        
        home-manager/ #user level override for programs for this user
            program1.nix #custom override for hyperos.programs.program1

hosts/
    machine1/
        default.nix # defines system specific configuration
        hardware.nix # defines hardware specifics for that system
        
        home-manager/ #user level override for programs for this machine
            program1.nix
            
        nixos/ #system level ovveride for programs for this machine
            program2.nix
            
modules/ #toggleable options to use inside of hosts/<machine>/ or homes/<user>/

    hardware/
        nvidia.nix #hyperos.hardware.nvidia.enable = <true/false>
        
    system/
        boot.nix #hyperos.system.boot
        
    profiles/ #useful combinations of options
        desktop.nix
        gaming.nix
        
    programs/
        programs.nix #list of all programs, hyperos.programs.example
        
        /* Any combination or lack of system or user level configurations can exist or
        can be automatically overriden, if it exist at the hosts/<machine>/ or homes/<user>/ level.
        It's all combined into a single programs.option for each program */
      
        nixos/ #system level configuration for programs
            program1.nix 
            
        home-manager/ #user level configuration for programs
            program1.nix

lib/ #system logic

pkgs/ #custom programs

dotfiles/ #user level data not possible to store with home-manager

secrets/
    samsara-control-matrix-passw.txt #ENCRYPTED ❌ CRANK WEINER HARDER FEDS 💯🤡 ALL MINE 😂

```
