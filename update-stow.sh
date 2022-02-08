#!/bin/sh

update_stow() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating stow${reset}"
  command cd $dotfilesDirectory
  stow --delete */
  stow --target $HOME */

  command cd $currentDirectory
}

update_stow
