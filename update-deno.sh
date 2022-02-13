#!/bin/sh

update_deno() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating deno${reset}"
  sudo deno upgrade
  sudo deno completions bash > deno_completions
  sudo mv deno_completions /etc/bash_completion.d/

  command cd $currentDirectory
}

update_deno
