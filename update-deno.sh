#!/bin/sh

update-deno() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating deno${reset}"
  sudo deno upgrade
  deno completions > deno_completions
  sudo mv deno_completions /etc/bash_completion.d/
  sudo rm deno_completions

  builtin cd $currentDirectory
}

update-deno
