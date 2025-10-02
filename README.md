# HyperOS: My NixOS Configuration
### Everything necessary to completely recreate my systems, and easily make new systems.

## Understanding the layout simply:

- `dotfiles/` non home-manager user level files
- `flake.nix` my system flake
- `homes/` folder to define specific users
- `hosts/` folder to define specific machines
- `lib/` folder to put commonly used functions
- `modules/` modules of software + nix code set to options
- `pkgs/` custom made packages
- `secrets/` encrypted secrets

## Features:

- I'll list them later when I remember

## To do

- move everything in hyperos/default.nix into modules/
- setup profiles
- setup secrets
- setup zfs or btrfs immutibility
- setup nixos server
- fix default machine and user to work with new modules
    
## Try HyperOS: It's so good!

1. "find" a computer with nixos installed
2. clone this repository to any spot
3. move hardware.nix to hosts/(hostname). To generate use nixos-generate-config
4. Copy the hosts/default/default.nix file to your host, edit it as you choose
    - make it easy options like `hyperos.profiles.desktop.enabled = true` or `hyperos.programs.steam.enabled = true`
5. Copy the homes/default/default.nix and home.nix into gomes/(youruser)/, edit it as you choose
    - add stuff here if you want them to only be installed if your user is added to a machine
6. In flake.nix, copy the default flake code. Rename and import your hosts/host/default.nix
7. run `sudo nixos-rebuild switch --flake .#hostname`

## Understanding the layout fully
```
dotfiles/ 
    program.txt
    program2.txt
```
```
flake.nix
```
```
homes/
    user1/
        default.nix
        home.nix
    user2/
        home-manager/ #home-manager configurations just for this user
            program1.nix
            program2.nix 
        default.nix #defines the user
        home.nix #defines the user home-manager configuration
```
```
hosts/
    machine1/
        default.nix
        hardware.nix
    machine2
        default.nix # defines system specific configuration
        hardware.nix # defines hardware specifics for that system
```
```
lib/
    default.nix #imports all lib for easy use
    mkSomething.nix
    mkSomething2.nix
```
```
modules/ #set options inside of hosts/machine/ or homes/user/
    hardware/
        cpu.nix
        gpu.nix #hyperos.hardware.gpu.nvidia.enabled = true;
    home-manager/
        program1.nix 
        program2.nix #hyperos.programs.program2.enabled = true;
    profiles/
        base.nix
        desktop.nix
        gaming.nix
    programs/
        _all.nix #single source of truth for possible software on hyperos systems
        default.nix #option creation logic
        program1.nix
        program2.nix #hyperos.programs.program2.enabled = true;
    system/
        boot.nix
        audio.nix
        
    README.md #more information on modules
```
```
pkgs/
    program3.nix #not in nixpkgs, flatpak, etc
```
```
secrets/
    samsara-control-matrix-passw.txt #ENCRYPTED ❌ CRANK WEINER HARDER FEDS 💯🤡 ALL MINE 😂
```
