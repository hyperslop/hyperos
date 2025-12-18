{ config, pkgs, inputs, lib, ... }:

{
  config = lib.mkIf config.hyperos.hardware.printing.enable {
    services.printing.enable = true; # Enable CUPS to print documents.
  };
}
