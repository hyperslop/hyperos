{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.hyperos.programs.obs-studio.enable {
    programs.obs-studio = {
        enable = true;

        plugins = with pkgs.obs-studio-plugins; [
            obs-pipewire-audio-capture
            obs-vaapi
            obs-vkcapture
            obs-gstreamer
        ];
    };
  };
}

