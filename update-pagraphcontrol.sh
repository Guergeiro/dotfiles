#!/bin/sh

update_alacritty() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating pagraphControl${reset}"
  command cd $pagraphControl
  git pull

  yarn install
  yarn -- build

  ln -s $pagraphControl/dist/pagraphcontrol-linux-x64/pagraphcontrol /usr/local/bin/pagraphcontrol

  command cd $currentDirectory
}

update_alacritty
