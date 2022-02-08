#!/bin/sh

update_colors() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating srcery-colors${reset}"
  command cd $srceryterminalDirectory
  git pull

  command cd $currentDirectory
}

update_colors
