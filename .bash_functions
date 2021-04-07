#!/bin/bash

function git() {
  if [ "$1" = "root" ]; then
    local ROOT="$(command git rev-parse --show-toplevel 2> /dev/null || pwd)"

    if [ "$#" -eq 1 ]; then
      echo "$ROOT"
    else
      if [ "$2" = "cd" ]; then
        command cd $ROOT
      else
        shift
        (cd "$ROOT" && eval "$@")
      fi
    fi
  elif [ "$1" = "prune" ]; then
    command git fetch --prune
  elif [ "$1" = "tree" ]; then
    command git log --graph
  elif [ "$1" = "branch" ] && [ "$#" -eq 1 ]; then
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

function deno() {
  docker run \
    --interactive \
    --tty \
    --rm \
    --volume $PWD:/usr/src/app \
    --volume $HOME/.deno:/deno-dir \
    --workdir /usr/src/app \
    hayd/alpine-deno \
    deno "$@"
}

function node() {
  docker run \
    --interactive \
    --tty \
    --rm \
    --volume $PWD:/usr/src/app \
    --workdir /usr/src/app \
    node:alpine \
    node "$@"
}

function npm() {
  if [ "$2" = "-g" ] || [ "$2" = "--global"]; then
    command npm "$@"
  else
    docker run \
      --interactive \
      --tty \
      --rm \
      --volume $PWD:/usr/src/app \
      --workdir /usr/src/app \
      node:alpine \
      npm "$@"
  fi
}

function yarn() {
  if [ "$1" = "global" ]; then
    command yarn "$@"
  else
    docker run \
      --interactive \
      --tty \
      --rm \
      --volume $PWD:/usr/src/app \
      --workdir /usr/src/app \
      node:12-alpine \
      yarn "$@"
  fi
}
