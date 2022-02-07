#!/bin/sh

update-rust() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating rust${reset}"
  rustup update stable

  builtin cd $currentDirectory
}

update-rust
