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
  elif [ "$1" = "commit" ] && [ "$2" = "timestamp" ]; then
    shift
    local current_date=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
    command git commit -m "$current_date"
  else
    command git "$@"
  fi
}

function cd() {
  local dir="$@"
  builtin cd $dir && ls -A --color=auto
}

# Check if internet is working
function ping() {
  if [ "$#" -ne 0 ]; then
    command ping "$@"
  else
    command ping "www.brenosalles.com"
  fi
}

function __battery-notify() {
  while true
  do
    export DISPLAY=:0.0
    local battery_percent=$(acpi -b | command grep -P -o '[0-9]+(?=%)')
    if [ "$battery_percent" -gt $1 ]; then
      notify-send "Level: ${battery_percent}% "
    fi
    sleep 300 # (5 minutes)
  done
}

function high-battery() {
  __battery-notify 80
}

function note() {
  local subDir="zettelkasten"

  __create_note "$subDir" "$@"
}

function reference-note() {
local subDir="reference-notes"
__create_note "$subDir" "$@"
}

function __create_note() {
  local current_date=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
  local name="$current_date.md"

  local subDir=$1
  shift

  if [ "$#" -ne 0 ]; then
    local name="$1.md"
    shift
  fi

  nvim -c "cd $notesDirectory" "$notesDirectory/$subDir/$name"
}

function __execute_default_command() {
  local command="$1"
  shift
  command $command "$@"
}

function textype() {
  file=$(readlink -f "$1")
  command="pdflatex"
  ( head -n5 "$file" | grep -qi 'xelatex' ) && command="xelatex"
  $command --output-directory="${file%/*}" "${file%.*}"
  grep -qi addbibresource "$file" &&
    biber --input-directory "${file%/*}" "${file%.*}" &&
    $command --output-directory="${file%/*}" "${file%.*}" &&
    $command --output-directory="${file%/*}" "${file%.*}"
  }
