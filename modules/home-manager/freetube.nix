{ config, pkgs, lib, ... }:

let
  sharedConfig = import ../../dotfiles;
in
{
  home.activation.linkFreeTube = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD rm -f ~/.config/FreeTube/profiles.db
    $DRY_RUN_CMD rm -f ~/.config/FreeTube/settings.db
    $DRY_RUN_CMD mkdir -p ~/.config/FreeTube
    $DRY_RUN_CMD ln -sf ${sharedConfig.dotfilesDir}/freetube/profiles.db ~/.config/FreeTube/profiles.db
    $DRY_RUN_CMD ln -sf ${sharedConfig.dotfilesDir}/freetube/settings.db ~/.config/FreeTube/settings.db
  '';
}
