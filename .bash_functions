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

function __docker_port(){
  # Generate random port to use https://en.wikipedia.org/wiki/Ephemeral_port#range
  # 65535-49152=16383 (max range)
  local port=$((49152 + $RANDOM % 16383))
  echo "$port"
}

function __docker_user(){
  local user="$(id --user)"
  echo "$user"
}

function __docker_user_name(){
  local user="$(id --user --name)"
  echo "$user"
}

function __docker_group(){
  local group="$(id --group)"
  echo "$group"
}

function __docker_home() {
  local dockerHome="/home/$(__docker_user_name)"
  echo "$dockerHome"
}

function __docker_default_args(){
  # Default args
  local args="--interactive"
  local args+=" --tty"
  local args+=" --rm"
  local args+=" --volume $PWD:$(__docker_home)/app"
  local args+=" --volume $HOME/.deno:/deno-dir"
  local args+=" --volume $HOME/.m2:$(__docker_home)/.m2"
  local args+=" --workdir $(__docker_home)/app"
  local args+=" --network host"
  # Check if .env file exits
  local file=".env"
  if [ -f $file ]; then
    local args+=" --env-file $file"
  fi
  echo "$args"
}

function __execute_default_command() {
  local command="$1"
  shift
  command $command "$@"
}

function deno() {
  if [ "$1" = "--" ]; then
    shift
    __execute_default_command "deno" "$@"
    return
  fi
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local port=$(__docker_port)
  local args=$(__docker_default_args)
  local args+=" --env PORT=$port"
  local args+=" --user $(__docker_user):$(__docker_group)"

  docker run \
    $args \
    denoland/deno:$version \
    deno "$@"
}

function node() {
  if [ "$1" = "--" ]; then
    shift
    __execute_default_command "node" "$@"
    return
  fi
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local port=$(__docker_port)
  local args=$(__docker_default_args)
  local args+=" --env PORT=$port"
  local args+=" --user $(__docker_user):$(__docker_group)"

  docker run \
    $args \
    node:$version \
    node "$@"
}

function python() {
  if [ "$1" = "--" ]; then
    shift
    __execute_default_command "python" "$@"
    return
  fi
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local port=$(__docker_port)
  local args=$(__docker_default_args)
  local args+=" --env PORT=$port"
  local args+=" --user $(__docker_user):$(__docker_group)"

  docker run \
    $args \
    python:$version \
    python "$@"
}

function pip() {
  if [ "$1" = "--" ]; then
    shift
    __execute_default_command "pip3" "$@"
    return
  fi
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local port=$(__docker_port)
  local args=$(__docker_default_args)
  local args+=" --env PORT=$port"
  local args+=" --user $(__docker_user):$(__docker_group)"

  docker run \
    $args \
    python:$version \
    pip "$@"
}

function pnpx() {
  __execute_default_command "pnpm exec" "$@"
}

function npm() {
  if [ "$1" = "--" ]; then
    shift
    __execute_default_command "npm" "$@"
    return
  fi
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local port=$(__docker_port)
  local args=$(__docker_default_args)
  local args+=" --env PORT=$port"
  local args+=" --user $(__docker_user):$(__docker_group)"

  docker run \
    $args \
    node:$version \
    npm "$@"
}

function yarn() {
  if [ "$1" = "--" ]; then
    shift
    __execute_default_command "yarn" "$@"
    return
  fi
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local port=$(__docker_port)
  local args=$(__docker_default_args)
  local args+=" --env PORT=$port"
  local args+=" --user $(__docker_user):$(__docker_group)"

  docker run \
    $args \
    node:$version \
    yarn "$@"
}

function mvn() {
  if [ "$1" = "--" ]; then
    shift
    __execute_default_command "mvn" "$@"
    return
  fi
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local port=$(__docker_port)
  local args=$(__docker_default_args)
  local args+=" --env PORT=$port"
  local args+=" --user $(__docker_user):$(__docker_group)"
  local args+=" --env MAVEN_CONFIG=$(__docker_home)/.m2"

  if [ "$1" = "run" ]; then
    shift
    docker run \
      $args \
      maven:$version \
      mvn -Duser.home="$(__docker_home)" exec:java "$@"
  elif [ "$1" = "init" ]; then
    shift
    docker run \
      $args \
      maven:$version \
      mvn archetype:generate \
      -DarchetypeArtifactId=maven-archetype-quickstart \
      -DarchetypeVersion=RELEASE \
      -Duser.home="$(__docker_home)" "$@"
  else
    docker run \
      $args \
      maven:$version \
      mvn -Duser.home="$(__docker_home)" "$@"
  fi
}

function gradle() {
  if [ "$1" = "--" ]; then
    shift
    __execute_default_command "gradle" "$@"
    return
  fi
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local args=$(__docker_default_args)
  local port=$(__docker_port)
  local args+=" --env PORT=$port"
  local args+=" --user $(__docker_user):$(__docker_group)"

  docker run \
    $args \
    gradle:$version \
    gradle "$@"
}

function java() {
  if [ "$1" = "--" ]; then
    shift
    __execute_default_command "java" "$@"
    return
  fi
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local args=$(__docker_default_args)
  local port=$(__docker_port)
  local args+=" --env PORT=$port"
  local args+=" --user $(__docker_user):$(__docker_group)"

  docker run \
    $args \
    openjdk:$version \
    java "$@"
}

function grip() {
  if [ "$1" = "--" ]; then
    shift
    __execute_default_command "grip" "$@"
    return
  fi
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi
  local args=$(__docker_default_args)
  local port=$(__docker_port)
  local args+=" --env PORT=$port"

  echo $@

  docker run \
    $args \
    python:$version \
    /bin/sh -c "pip install --no-cache-dir grip && grip \"$@\" 0.0.0.0:\"$port\""

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
