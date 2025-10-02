# lib/default.nix
{ lib, ... }:

{
  mkProgramModule = import ./mkProgramModule.nix { inherit lib; };
  mkFlatpakModule = import ./mkProgramModule.nix { inherit lib; };
}
