#!/bin/sh

execute() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local dotfilesDirectory=$HOME/Documents/guergeiro/dotfiles
  local vimDirectory=$HOME/Documents/vim/vim
  local srceryterminalDirectory=$HOME/Documents/srcery-colors/srcery-terminal
  local alacrittyDirectory=$HOME/Documents/alacritty/alacritty
  local nerdfontsDirectory=$HOME/Documents/ryanoasis/nerd-fonts

  echo "${yellow}Updating starship${reset}"
  echo "dotfilesDirectory=$dotfilesDirectory" >> $HOME/.bashrc
  echo "vimDirectory=$vimDirectory" >> $HOME/.bashrc
  echo "srceryterminalDirectory=$srceryterminalDirectory" >> $HOME/.bashrc
  echo "alacrittyDirectory=$alacrittyDirectory" >> $HOME/.bashrc
  echo "nerdfontsDirectory=$nerdfontsDirectory" >> $HOME/.bashrc
}

execute
