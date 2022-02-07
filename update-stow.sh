#!/bin/sh

update-stow() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating stow${reset}"
  builtin cd $dotfilesDirectory
  stow --delete */
  stow --target $HOME */

  builtin cd $currentDirectory
}

update-stow
