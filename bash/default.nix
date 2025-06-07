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
    bashrcExtra = ''
      function docker-compose() {
        if [ "$1" = "up" ]; then
          shift
          command docker compose up --remove-orphans --build "$@"
        else
          command docker compose "$@"
        fi
      }

      eval "$(direnv hook bash)"
    '';
  };
}
