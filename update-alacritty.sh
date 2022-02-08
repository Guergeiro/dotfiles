#!/bin/sh

update_alacritty() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating alacritty${reset}"
  command cd $alacrittyDirectory
  git pull
  cargo build --release
  # Terminfo
  sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
  # Desktop entry
  sudo cp target/release/alacritty /usr/bin
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database
  # Man page
  sudo mkdir -p /usr/local/share/man/man1
  gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
  # Shell completions
  sudo cp extra/completions/alacritty.bash /etc/bash_completion.d/alacritty

  command cd $currentDirectory
}

update_alacritty
