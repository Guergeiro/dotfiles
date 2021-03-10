#!/bin/bash
function git() {
  if [ "$1" = "root" ]; then
    shift

    local ROOT="$(command git rev-parse --show-toplevel 2> /dev/null || pwd)"

    if [ $# -eq 0 ]; then
      echo "$ROOT"
    else
      (cd "$ROOT" && eval "$@")
    fi
  elif [ "$1" = "prune" ]; then
    shift
    command git fetch --prune
  elif [[ "$1" = "branch" && "$#" -eq 1 ]]; then
    shift
    command git branch -a
  else
    command git "$@"
  fi
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
