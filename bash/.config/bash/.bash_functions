#!/bin/bash

function update() {
  if [ "$1" = "dpki" ]; then
    sudo apt-get -f install
  elif [ "$1" = "alacritty" ]; then
    . $dotfilesDirectory/update-alacritty.sh
  elif [ "$1" = "colors" ]; then
    . $dotfilesDirectory/update-colors.sh
  elif [ "$1" = "deno" ]; then
    . $dotfilesDirectory/update-deno.sh
  elif [ "$1" = "fonts" ]; then
    . $dotfilesDirectory/update-fonts.sh
  elif [ "$1" = "rust" ]; then
    . $dotfilesDirectory/update-rust.sh
  elif [ "$1" = "starship" ]; then
    . $dotfilesDirectory/update-starship.sh
  elif [ "$1" = "vim" ]; then
    . $dotfilesDirectory/update-vim.sh
  elif [ "$1" = "all" ]; then
    . $dotfilesDirectory/update-alacritty.sh
    . $dotfilesDirectory/update-colors.sh
    . $dotfilesDirectory/update-deno.sh
    . $dotfilesDirectory/update-fonts.sh
    . $dotfilesDirectory/update-rust.sh
    . $dotfilesDirectory/update-starship.sh
    . $dotfilesDirectory/update-vim.sh
  else
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -y
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y
  fi
}

function git() {
  if [ "$1" = "root" ]; then
    local root="$(command git rev-parse --show-toplevel 2> /dev/null || pwd)"

    if [ "$#" -eq 1 ]; then
      echo "$root"
    elif [ "$2" = "cd" ]; then
      command cd $root
    else
      shift
      (cd "$root" && eval "$@")
    fi
  elif [ "$1" = "prune" ]; then
    shift
    command git fetch origin --prune
    command git fetch upstream --prune
    command git fetch github --prune
  elif [ "$1" = "tree" ]; then
    shift
    command git log --graph
  elif [ "$1" = "branch" ] && [ "$#" -eq 1 ]; then
    shift
    command git branch -a
  else
    command git "$@"
  fi
}

function cd() {
  local dir="$@"
  builtin cd $dir && ls -A --color=auto
}

function man() {
  LESS_TERMCAP_md=$'\e[01;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;44;33m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  command man "$@"
}

# Check if internet is working
function ping() {
  if [ "$#" -ne 0 ]; then
    command ping "$@"
  else
    command ping "www.brenosalles.com"
  fi
}

function __execute_default_command() {
  local command="$1"
  shift
  command $command "$@"
}

function pnpx() {
  __execute_default_command "pnpm exec" "$@"
}