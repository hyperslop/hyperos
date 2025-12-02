{ config, pkgs, lib, ... }:

let
  sharedConfig = import ../../../dotfiles;
  dotfilesDir = sharedConfig.dotfilesDir;
in
{
  # Watch for changes and auto-sync
  systemd.user.services.freetube-autosync = {
    Unit = {
      Description = "Auto-sync FreeTube config to dotfiles";
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "freetube-watch" ''
        ${pkgs.inotify-tools}/bin/inotifywait -m -e close_write ~/.config/FreeTube/ |
        while read path action file; do
          if [[ "$file" == "profiles.db" ]] || [[ "$file" == "settings.db" ]]; then
            echo "$(date): Syncing $file to dotfiles"
            cp ~/.config/FreeTube/"$file" ${dotfilesDir}/freetube/"$file"
          fi
        done
      ''}";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
