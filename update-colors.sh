#!/bin/sh

update-colors() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating srcery-colors${reset}"
  builtin cd $srceryterminalDirectory
  git pull

  builtin cd $currentDirectory
}

update-colors
