#!/bin/sh

update_cursor() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating cursor${reset}"
  command cd $cursorDirectory
  git pull
  sudo apt-get install inkscape x11-apps -y
  ./build.sh -t dark -d xxxhd
  ./build.sh -t light -d xxxhd
  if [ ! -d "/usr/share/icons/capitaine-cursors-dark" ]; then
    sudo mkdir /usr/share/icons/capitaine-cursors-dark
  fi
  sudo cp -r dist/dark/* /usr/share/icons/capitaine-cursors-dark
  if [ ! -d "/usr/share/icons/capitaine-cursors-light" ]; then
    sudo mkdir /usr/share/icons/capitaine-cursors-light
  fi
  sudo cp -r dist/light/* /usr/share/icons/capitaine-cursors-light

  command cd $currentDirectory
}

update_cursor
