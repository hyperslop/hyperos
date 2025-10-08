{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    historySize = 10000;
    historyFileSize = 20000;

    initExtra = ''
      # Append to history, don't overwrite
      shopt -s histappend

      # Write to history immediately after each command
      PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
    '';

    shellAliases = {
      #ll = "ls -la";
    };
  };
}
