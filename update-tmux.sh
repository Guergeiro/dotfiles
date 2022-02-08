#!/bin/sh

update_tmux() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating tmux${reset}"
  sudo apt-get purge tmux* -y
  command cd $tmuxDirectory
  git pull
  sh autogen.sh
  ./configure
  make
  sudo make install

  command cd $currentDirectory
}

update_tmux
