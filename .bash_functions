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
    sudo npm update -g yarn
    sudo yarn global upgrade
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
  if [ "$1" = "vim" ]; then
    local dir=$vimDirectory
  elif [ "$1" = "dotfiles" ]; then
    local dir=$dotfilesDirectory
  fi
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
  # Default args
  local args="--interactive"
  local args+=" --tty"
  local args+=" --rm"
  local args+=" --user $(id --user):$(id --group)"
  local args+=" --volume $PWD:/usr/src/app"
  local args+=" --volume $HOME/.deno:/deno-dir"
  local args+=" --workdir /usr/src/app"
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
  if [ "$2" = "-g" ] || [ "$2" = "--global" ]; then
    command npm "$@"
  else
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
  fi
}

function yarn() {
  if [ "$1" = "global" ]; then
    command yarn "$@"
  else
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

# Check if internet is working
function ping() {
  if [ "$#" -ne 0 ]; then
    command ping "$@"
  else
    command ping "www.brenosalles.com"
  fi
}

function update_branch() {
  local branch="master"
  if [ "$#" -ne 0 ]; then
    local branch=$1
    shift
  fi
  git checkout "$branch"
  git pull --all
  git fetch upstream --prune
  git fetch --prune
  git push "$branch"
}

function update_all() {
  local curPwd=$(pwd)
  local currDirs=$(find $curPwd -mindepth 1 -maxdepth 1 -type d | xargs realpath)
  for d in $currDirs; do
    if [ -d "$d/.git" ]; then
      cd $d
      update_git
    fi
  done
  cd $curPwd
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

function startWork() {
  while [ "$#" -gt 0 ]; do
    local curr=$1
    shift

    case "$curr" in
    "bolsas")
      local directory=$HOME/Documents/libertrium/bolsas
      createSession bolsas primary
      createWindow bolsas docker -c $directory  "docker-compose up --remove-orphans --build"
      createPane bolsas docker -c $directory
      createWindow bolsas apicm_bolsas -c $directory/apicm_bolsas
      createWindow bolsas apiuser_bolsas -c $directory/apiuser_bolsas
      createWindow bolsas cm_bolsas -c $directory/cm_bolsas
      createWindow bolsas user_bolsas -c $directory/user_bolsas
      ;;

    "associativismo")
      local directory=$HOME/Documents/libertrium/associativismo
      createSession associativismo primary
      createWindow associativismo docker -c $directory  "docker-compose up --remove-orphans --build"
      createPane associativismo docker -c $directory
      createWindow associativismo apicm_associativismo -c $directory/apicm_associativismo
      createWindow associativismo apiuser_associativismo -c $directory/apiuser_associativismo
      createWindow associativismo cm_associativismo -c $directory/cm_associativismo
      createWindow associativismo user_associativismo -c $directory/user_associativismo
      ;;

    "brenosalles")
      local directory=$HOME/Documents/guergeiro/breno-website
      createSession breno primary
      createWindow breno docker -c $directory  "docker-compose up --remove-orphans --build"
      createPane breno docker -c $directory
      createWindow breno api -c $directory/api.brenosalles.com
      createWindow breno angular -c $directory/brenosalles.com
      ;;

    "drash")
      local directory=$HOME/Documents/drashland/deno-drash
      createSession drash primary -c $directory
      ;;

    "unilogger")
      local directory=$HOME/Documents/guergeiro/unilogger
      createSession unilogger primary -c $directory
      ;;

    *) echo "Unavailable command... $curr"
    esac
  done
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

