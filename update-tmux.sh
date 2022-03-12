#!/bin/sh

update_tmux() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating tmux${reset}"
  sudo apt-get purge tmux* -y
  sudo apt-get install autoconf -y
  sudo apt-get install automake -y
  sudo apt-get install pkg-config -y
  command cd $tmuxDirectory
  git pull
  sh autogen.sh
  ./configure
  make
  sudo make install

  command cd $currentDirectory
}

update_tmux
