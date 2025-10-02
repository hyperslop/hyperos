# Understanding Modules

## Understanding system/ & hardware/
### Each file has an associated boolean option

| location | option |
| ------------- |:-------------:|
| system/boot.nix     | `hyperos.system.boot`    |
| system/audio.nix      | `hyperos.system.audio`    |
| hardware/gpu/nvidia.nix    | `hyperos.hardware.gpu.nvidia`    |

## Understanding programs/ & home-manager/
### In programs/_all.nix all software is listed associated with a boolean option

**understand _all.nix as the single source of truth for what software is on hyperos**

1. It installs the package of the same name if it exists
2. It checks if there is an associated programs/name.nix file, if so it's imported
3. It checks if there is an associated home-manager/name.nix file, if so it's imported

`logic in: modules/programs/default.nix + lib/mkProgramModule.nix`

| location | option |
| ------------- |:-------------:|
| programs/docker.nix    | `hyperos.programs.docker`    |
| programs/git.nix + home-manager/git.nix      | `hyperos.programs.git`   |
| "fastfetch" in programs/_all.nix    | `hyperos.programs.fastfetch`   |
|  home-manager/firefox.nix | `hyperos.programs.firefox` |
| programs/old.nix (removed from _all.nix) | no option exists |


**I dont want this stupid home-manager configuration**

`hyperos.programs.git = {  enable = true;  enableHomeManager = false; };`

**I dont want this stupid extra nixos configuration**

`environment.systemPackages = [ pkgs.git ];` and get yourself checked! 

## Understanding profiles/
profiles are easy to use combinations of hyperos.* options

| option | simplified example sets  |
| ------------- |:-------------:|
| `hyperos.profiles.base`   | `hyperos.system.boot` + `hyperos.programs.git` |
| `hyperos.profiles.desktop`     | `hyperos.profiles.base` + `hyperos.system.audio` + `hyperos.programs.kde` + `hyperos.hardware.gpu.detect`  |
| `hyperos.profiles.gaming`    | `hyperos.profiles.desktop` + `hyperos.programs.steam`  |
|  `hyperos.profiles.virtualisation` | `hyperos.profiles.desktop` + `hyperos.programs.virt-manager` + `hyperos.programs.qemu` |

Enabling profiles just sets the sub options to be true by default. You can explicity disable anything.

## The system in action

```
hyperos.profiles.gaming.enabled = true;
hyperos.profiles.virtualisation.enabled = true;

hyperos.programs.kde.enabled = false;
hyperos.programs.hyprland.enabled = true; # swap kde for hyprland

hyperos.programs.lutris.enabled = true; # add lutris
```
### What is happening?
enabling steam or lutris **automatically** adds proton-ge + gpu optimizations for games

enabling virt-manager (enabled by profile.virtualisation) **automatically** enables the libvirtd service and adds users to the libvirt group

when enabling hyperos.profiles.gaming it not only sets up gaming but a display server, desktop, and basic system utilities needed to support gaming

### enabling a programs or profile will enable any services or system level optimization

you can swap out any software from the profiles, or not use profiles:
* hyperos.profiles.gaming without steam still gives gaming optimizations
* hyperos.programs.steam without hyperos.profiles.gaming still gives gaming optimizations

**enabling just hyperos.programs.steam can automatically install packages it needs to function/optimize (display server, gaming optimizations, proton-ge)**
> You should never break the system by enabling any option and not another, and not have the best optimized experience (opinionated hyperos experience)


