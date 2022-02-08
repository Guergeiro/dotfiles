#!/bin/sh

update_fonts() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating fonts${reset}"
  command cd $nerdfontsDirectory
  git pull
  ./install.sh

  command cd $currentDirectory
}

update_fonts
