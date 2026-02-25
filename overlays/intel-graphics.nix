{ inputs, ... }:
final: prev:
let
  pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${final.system};
in {
  intel-graphics-compiler = pkgs-stable.intel-graphics-compiler;
  intel-compute-runtime = pkgs-stable.intel-compute-runtime;
}
