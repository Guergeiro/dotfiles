#!/bin/sh

update_colors() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating dracula${reset}"
  command cd $draculaterminalDirectory
  git pull

  command cd $currentDirectory
}

update_colors
