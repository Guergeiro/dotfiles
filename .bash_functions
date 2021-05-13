#!/bin/bash

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
  local version="alpine-deno"
  if [ "$1" = "--docker" ]; then
    shift
    version="$1"
    shift
  fi
  docker run \
    --interactive \
    --tty \
    --rm \
    --user $(id --user):$(id --group) \
    --volume $PWD:/usr/src/app \
    --volume $HOME/.deno:/deno-dir \
    --workdir /usr/src/app \
    hayd/$version \
    deno "$@"
}

function node() {
  local version="current-alpine"
  if [ "$1" = "--docker" ]; then
    shift
    version="$1"
    shift
  fi
  docker run \
    --interactive \
    --tty \
    --rm \
    --user $(id --user):$(id --group) \
    --volume $PWD:/usr/src/app \
    --workdir /usr/src/app \
    node:$version \
    node "$@"
}

function npm() {
  if [ "$2" = "-g" ] || [ "$2" = "--global" ]; then
    command npm "$@"
  else
    local version="current-alpine"
    if [ "$1" = "--docker" ]; then
      shift
      version="$1"
      shift
    fi
    docker run \
      --interactive \
      --tty \
      --rm \
      --user $(id --user):$(id --group) \
      --volume $PWD:/usr/src/app \
      --workdir /usr/src/app \
      node:$version \
      npm "$@"
  fi
}

function yarn() {
  if [ "$1" = "global" ]; then
    command yarn "$@"
  else
    local version="current-alpine"
    if [ "$1" = "--docker" ]; then
      shift
      version="$1"
      shift
    fi
    docker run \
      --interactive \
      --tty \
      --rm \
      --user $(id --user):$(id --group) \
      --volume $PWD:/usr/src/app \
      --workdir /usr/src/app \
      node:$version \
      yarn "$@"
  fi
}

function docker-compose() {
  if [ "$1" = "up" ]; then
    shift
    command docker-compose up --remove-orphans --build "$@"
  else
    command docker-compose "$@"
  fi
}
