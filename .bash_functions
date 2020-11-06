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
  else
    command git "$@"
  fi
}
