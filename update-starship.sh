#!/bin/sh

update_starship() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating starship${reset}"
  sh -c "$(curl -fsSL https://starship.rs/install.sh)"

  command cd $currentDirectory
}

update_starship
