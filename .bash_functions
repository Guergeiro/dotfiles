#!/bin/bash

function update() {
  if [ "$1" = "dpki" ]; then
    sudo apt-get -f install
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
    command git fetch --prune
    command git fetch upstream --prune
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

function __docker_default_args(){
  local dockerHome="/home/$(id --user --name)"
  # Default args
  local args="--interactive"
  local args+=" --tty"
  local args+=" --rm"
  local args+=" --user $(id --user):$(id --group)"
  local args+=" --volume $PWD:$dockerHome/src"
  local args+=" --volume $HOME/.deno:/deno-dir"
  local args+=" --volume $HOME/.pnpm-store:$dockerHome/.pnpm-store"
  local args+=" --volume $HOME/.m2:$dockerHome/maven/.m2"
  local args+=" --env MAVEN_CONFIG=$dockerHome/maven/.m2"
  local args+=" --workdir $dockerHome/src"
  # Generate random port to use https://en.wikipedia.org/wiki/Ephemeral_port#range
  # 65535-49152=16383 (max range)
  local port=$((49152 + $RANDOM % 16383))
  local args+=" --env PORT=$port"
  local args+=" --network host"
  # Check if .env file exits
  local file=".env"
  if [ -f $file ]; then
    local args+=" --env-file $file"
  fi
  echo "$args"
}

function deno() {
  local version="debian"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local args=$(__docker_default_args)

  docker run \
    $args \
    denoland/deno:$version \
    deno "$@"
}

function node() {
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local args=$(__docker_default_args)

  docker run \
    $args \
    node:$version \
    node "$@"
}

function npm() {
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local args=$(__docker_default_args)

  docker run \
    $args \
    node:$version \
    npm "$@"
}

function yarn() {
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local args=$(__docker_default_args)

  docker run \
    $args \
    node:$version \
    yarn "$@"
}

function pnpm() {
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local args=$(__docker_default_args)

  docker run \
    $args \
    guergeiro/pnpm:$version \
    /bin/sh -c "\
    pnpm config set store-dir /home/$(id --user --name)/.pnpm-store && \
    pnpm \"$@\"\
    "
}

function mvn() {
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local args=$(__docker_default_args)
  docker run \
    $args \
    maven:$version \
    mvn -D user.home=$HOME/maven archetype:generate "$@"
}

function java() {
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local args=$(__docker_default_args)
  docker run \
    $args \
    openjdk:$version \
    java "$@"
}

function docker-compose() {
  if [ "$1" = "up" ]; then
    shift
    command docker-compose up --remove-orphans --build "$@"
  else
    command docker-compose "$@"
  fi
}

# Check if internet is working
function ping() {
  if [ "$#" -ne 0 ]; then
    command ping "$@"
  else
    command ping "www.brenosalles.com"
  fi
}

function createPane() {
  local session=$1
  shift
  local window=$1
  shift
  local direction="-h"
  tmux split-window $direction -t $session:$window -d "$@"
}

function createWindow() {
  local session=$1
  shift
  local window=$1
  shift
  tmux new-window -t $session: -n $window -d "$@"
}

function createSession() {
  local session=$1
  shift
  local window=$1
  shift
  tmux new -s $session -d -n $window "$@"
}


function goTmux() {
  if [ "$#" -eq 0 ]; then
    echo "No argument provided"
    return 1
  fi
  local arg=$1
  shift
  local session=$(tmux list-sessions | grep "^$arg")
  if [ "$session" = "" ]; then
    echo "No session called ${arg} available"
    return 1
  fi
  if [ ! -z "${TMUX+x}" ]; then
    tmux switch-client -t $arg
  else
    tmux attach -t $arg
  fi
}
