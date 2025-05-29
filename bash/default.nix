{ ... }:
{
  programs.bash = {
    enable = true;
    historyControl = [ "ignoreboth" ];
    shellOptions = [
      # append to the history file, don't overwrite it
      "histappend"
      # update the values of LINES and COLUMNS.
      "checkwinsize"
      # Removes the need of using cd
      "autocd"
      # Automatically tries it's best to correct misspell
      "cdspell"
    ];
  };

  # Note, if you use NixOS or nix-darwin and do not have Bash completion enabled in the system configuration, then make sure to add
  environment.pathsToLink = [ "/share/bash-completion" ];
}
