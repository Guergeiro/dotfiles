#!/bin/sh

install_dotfiles() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`

  local dotfilesDirectory="$HOME/Documents/guergeiro/dotfiles"
  local draculaterminalDirectory="$HOME/Documents/dracula/alacritty"
  local alacrittyDirectory="$HOME/Documents/alacritty/alacritty"
  local tmuxDirectory="$HOME/Documents/tmux/tmux"
  local nerdfontsDirectory="$HOME/Documents/ryanoasis/nerd-fonts"
  local notesDirectory="$HOME/Brain"

  echo "${yellow}Updating/Cleaning Packages${reset}"
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get dist-upgrade -y
  sudo apt-get autoremove -y
  sudo apt-get autoclean -y

  echo "${yellow}Installing Git${reset}"
  sudo apt-get install git -y

  echo "${yellow}Cloning Git Repos${reset}"
  git clone https://github.com/Guergeiro/dotfiles.git $dotfilesDirectory
  git clone https://github.com/dracula/alacritty.git $draculaterminalDirectory
  git clone https://github.com/alacritty/alacritty.git $alacrittyDirectory
  git clone https://github.com/tmux/tmux.git $tmuxDirectory
  git clone https://github.com/ryanoasis/nerd-fonts.git $nerdfontsDirectory
  git clone https://github.com/Guergeiro/Brain.git $notesDirectory


  echo "${yellow}Installing stow${reset}"
  sudo apt-get install stow -y
  command rm -rdf $HOME/.bashrc
  . $dotfilesDirectory/update-stow.sh
  . $HOME/.bashrc

  echo "${yellow}Installing Zip and Rar${reset}"
  sudo apt-get install zip unzip rar gzip -y

  echo "${yellow}Installing Tmux${reset}"
  . $dotfilesDirectory/update-tmux.sh

  echo "${yellow}Installing Rust${reset}"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  . $CARGO_HOME/env
  rustup override set stable
  . $dotfilesDirectory/update-rust.sh

  echo "${yellow}Installing Deno${reset}"
  curl -fsSL https://deno.land/x/install/install.sh | sudo DENO_INSTALL=/usr sh
  . $dotfilesDirectory/update-deno.sh

  echo "${yellow}Installing Python3${reset}"
  sudo apt-get install python3 -y
  sudo apt-get install python3-pip -y

  echo "${yellow}Installing OpenJDK (Headless)${reset}"
  sudo apt-get install default-jdk-headless -y

  echo "${yellow}Installing bat${reset}"
  sudo apt-get install bat -y

  echo "${yellow}Installing ripgrep${reset}"
  sudo apt-get install ripgrep -y

  echo "${yellow}Installing Trash CLI${reset}"
  sudo apt-get install trash-cli -y

  echo "${yellow}Installing XCLIP${reset}"
  sudo apt-get install xclip -y

  echo "${yellow}Installing Docker${reset}"
  sudo groupadd docker
  sudo usermod -aG docker $USER
  sudo apt-get purge docker* containerd runc
  curl -fsSL https://get.docker.com | sh

  echo "${yellow}Installing Docker Compose${reset}"
  sudo apt-get update
  sudo apt-get install docker-compose-plugin -y

  echo "${yellow}Installing pnpm${reset}"
  curl -fsSL https://get.pnpm.io/install.sh | sh -

  echo "${yellow}Installing neovim${reset}"
  sudo apt-get install software-properties-common python-dev python-pip \
    python3-dev python3-pip -y
  sudo add-apt-repository ppa:neovim-ppa/stable
  sudo apt-get update
  sudo apt-get install neovim -y

  . $dotfilesDirectory/update-alacritty.sh
  . $dotfilesDirectory/update-colors.sh
  . $dotfilesDirectory/update-deno.sh
  . $dotfilesDirectory/update-fonts.sh
  . $dotfilesDirectory/update-rust.sh
  . $dotfilesDirectory/update-starship.sh
  . $dotfilesDirectory/update-stow.sh
  . $dotfilesDirectory/update-tmux.sh
}

install_dotfiles
