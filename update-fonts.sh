#!/bin/sh

update_fonts() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating fonts${reset}"
  builtin cd $nerdfontsDirectory
  git pull
  ./install.sh

  builtin cd $currentDirectory
}

update_fonts
