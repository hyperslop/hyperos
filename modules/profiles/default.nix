{ config, pkgs, inputs, lib, ... }:

{
  config = lib.mkIf config.hyperos.profiles.default.enable {
  };
}
