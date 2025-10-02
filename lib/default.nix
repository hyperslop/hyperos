# lib/default.nix
{ lib, ... }:

{
  mkProgramModule = import ./mkProgramModule.nix { inherit lib; };
}
