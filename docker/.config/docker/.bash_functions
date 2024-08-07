#!/bin/bash

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
  mkdir -p "$XDG_CACHE_HOME/deno"
  mkdir -p "$XDG_CACHE_HOME/go"
  mkdir -p "$XDG_CACHE_HOME/go-build"
  mkdir -p "$HOME/.m2"

  # Default args
  local args="--interactive"
  local args+=" --tty"
  local args+=" --rm"
  local args+=" --volume $PWD:$(__docker_home)/app"
  local args+=" --volume $XDG_CACHE_HOME/deno:/deno-dir"
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

function air() {
  if [ "$1" = "--" ]; then
    shift
    __execute_default_command "air" "$@"
    return
  fi
  local version="latest"
  # Check for flag version
  if [ "$1" = "--docker" ]; then
    shift
    local version="$1"
    shift
  fi

  docker pull cosmtrek/air:$version

  local port=$(__docker_port)
  local args=$(__docker_default_args)
  local args+=" --env PORT=$port"
  local args+=" --env air_wd=$(__docker_home)/app"

  echo "http://0.0.0.0:$port"

  docker run \
    $args \
    cosmtrek/air:$version \
    "$@"
}

# function deno() {
#   if [ "$1" = "--" ]; then
#     shift
#     __execute_default_command "deno" "$@"
#     return
#   fi
#   local version="latest"
#   # Check for flag version
#   if [ "$1" = "--docker" ]; then
#     shift
#     local version="$1"
#     shift
#   fi
#   local port=$(__docker_port)
#   local args=$(__docker_default_args)
#   local args+=" --env PORT=$port"
#   local args+=" --user $(__docker_user):$(__docker_group)"

#   docker pull denoland/deno:$version

#   docker run \
#     $args \
#     denoland/deno:$version \
#     deno "$@"
# }

# function go() {
#   if [ "$1" = "--" ]; then
#     shift
#     __execute_default_command "go" "$@"
#     return
#   fi
#   local version="latest"
#   # Check for flag version
#   if [ "$1" = "--docker" ]; then
#     shift
#     local version="$1"
#     shift
#   fi
#   local port=$(__docker_port)
#   local args=$(__docker_default_args)
#   local args+=" --env PORT=$port"
#   local args+=" --user $(__docker_user):$(__docker_group)"

#   docker pull golang:$version

#   docker run \
#     $args \
#     golang:$version \
#     go "$@"
# }

# function node() {
#   if [ "$1" = "--" ]; then
#     shift
#     __execute_default_command "node" "$@"
#     return
#   fi
#   local version="latest"
#   # Check for flag version
#   if [ "$1" = "--docker" ]; then
#     shift
#     local version="$1"
#     shift
#   fi
#   local port=$(__docker_port)
#   local args=$(__docker_default_args)
#   local args+=" --env PORT=$port"
#   local args+=" --user $(__docker_user):$(__docker_group)"

#   docker pull node:$version

#   docker run \
#     $args \
#     node:$version \
#     node "$@"
# }

# function python() {
#   if [ "$1" = "--" ]; then
#     shift
#     __execute_default_command "python" "$@"
#     return
#   fi
#   local version="latest"
#   # Check for flag version
#   if [ "$1" = "--docker" ]; then
#     shift
#     local version="$1"
#     shift
#   fi
#   local port=$(__docker_port)
#   local args=$(__docker_default_args)
#   local args+=" --env PORT=$port"
#   local args+=" --user $(__docker_user):$(__docker_group)"

#   docker pull python:$version

#   docker run \
#     $args \
#     python:$version \
#     python "$@"
# }

# function pip() {
#   if [ "$1" = "--" ]; then
#     shift
#     __execute_default_command "pip3" "$@"
#     return
#   fi
#   local version="latest"
#   # Check for flag version
#   if [ "$1" = "--docker" ]; then
#     shift
#     local version="$1"
#     shift
#   fi
#   local port=$(__docker_port)
#   local args=$(__docker_default_args)
#   local args+=" --env PORT=$port"
#   local args+=" --user $(__docker_user):$(__docker_group)"

#   docker pull python:$version

#   docker run \
#     $args \
#     python:$version \
#     pip "$@"
# }

# function npm() {
#   if [ "$1" = "--" ]; then
#     shift
#     __execute_default_command "npm" "$@"
#     return
#   fi
#   local version="latest"
#   # Check for flag version
#   if [ "$1" = "--docker" ]; then
#     shift
#     local version="$1"
#     shift
#   fi
#   local port=$(__docker_port)
#   local args=$(__docker_default_args)
#   local args+=" --env PORT=$port"
#   local args+=" --user $(__docker_user):$(__docker_group)"

#   docker pull node:$version

#   docker run \
#     $args \
#     node:$version \
#     npm "$@"
# }

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

  docker pull node:$version

  docker run \
    $args \
    node:$version \
    yarn "$@"
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

  docker pull python:$version

  docker run \
    $args \
    python:$version \
    /bin/sh -c "pip install --no-cache-dir grip && grip \"$@\" 0.0.0.0:\"$port\""
}

function docker-compose() {
  if [ "$1" = "up" ]; then
    shift
    command docker compose up --remove-orphans --build "$@"
  else
    command docker compose "$@"
  fi
}
