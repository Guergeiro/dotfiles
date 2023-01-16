#!/bin/bash

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
    echo "No session called \"${arg}\" available"
    return 1
  fi
  if [ ! -z "${TMUX+x}" ]; then
    tmux switch-client -t $arg
  else
    tmux attach -t $arg
  fi
}
