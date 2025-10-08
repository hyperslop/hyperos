{ pkgs-stable ? null, ... }:
[
  # Intel graphics compiler fix for laptop
  (final: prev: {
    intel-graphics-compiler =
      if pkgs-stable != null
      then pkgs-stable.intel-graphics-compiler
      else prev.intel-graphics-compiler;
  })

  # Add more overlays here as needed
  # (final: prev: {
  #   someOtherPackage = pkgs-stable.someOtherPackage;
  # })
]
