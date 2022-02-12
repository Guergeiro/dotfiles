#!/bin/sh

update_alacritty() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating pagraphControl${reset}"
  command cd $pagraphControl
  git pull

  command cd $currentDirectory
}

update_alacritty
