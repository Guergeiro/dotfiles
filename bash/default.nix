{ pkgs, ... }:
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
          command ${pkgs.docker}/bin/docker compose up --remove-orphans --build "$@"
        else
          command ${pkgs.docker}/bin/docker compose "$@"
        fi
      }

      function cd() {
        local dir="$@"
        builtin cd $dir && ls -A --color=auto
      }

      # Check if internet is working
      function ping() {
        if [ "$#" -ne 0 ]; then
          command ping "$@"
        else
          command ping "www.brenosalles.com"
        fi
      }

      eval "$(direnv hook bash)"
    '';
  };
}
