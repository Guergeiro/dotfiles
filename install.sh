#!/bin/sh

install_dotfiles() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`

  local dotfilesDirectory=$HOME/Documents/guergeiro/dotfiles
  local vimDirectory=$HOME/Documents/vim/vim
  local srceryterminalDirectory=$HOME/Documents/srcery-colors/srcery-terminal
  local draculaterminalDirectory=$HOME/Documents/dracula/alacritty
  local alacrittyDirectory=$HOME/Documents/alacritty/alacritty
  local tmuxDirectory=$HOME/Documents/tmux/tmux
  local pagraphControl=$HOME/Documents/futpib/pagraphcontrol
  local nerdfontsDirectory=$HOME/Documents/ryanoasis/nerd-fonts
  local cursorDirectory=$HOME/Documents/keeferrourke/capitaine-cursors
  local notesDirectory=$HOME/Brain

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
  git clone https://github.com/vim/vim.git $vimDirectory
  git clone https://github.com/srcery-colors/srcery-terminal.git $srceryterminalDirectory
  git clone https://github.com/dracula/alacritty.git $draculaterminalDirectory
  git clone https://github.com/alacritty/alacritty.git $alacrittyDirectory
  git clone https://github.com/tmux/tmux.git $tmuxDirectory
  git clone https://github.com/futpib/pagraphcontrol.git $pagraphControl
  git clone https://github.com/ryanoasis/nerd-fonts.git $nerdfontsDirectory
  git clone https://github.com/keeferrourke/capitaine-cursors.git $cursorDirectory
  git clone https://github.com/Guergeiro/Brain.git $notesDirectory


  echo "${yellow}Installing stow${reset}"
  sudo apt-get install stow -y
  command rm -rdf $HOME/.bashrc
  . $dotfilesDirectory/update-stow.sh
  . $HOME/.bashrc

  echo "${yellow}Installing extra packages${reset}"
  # https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source
  sudo apt-get install libncurses5-dev libgtk2.0-dev libatk1.0-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python2-dev \
    python3-dev ruby-dev lua5.2 liblua5.2-dev libperl-dev \
    libevent-dev ncurses-dev build-essential bison \
    cmake pkg-config libfreetype6-dev libfontconfig1-dev \
    libxcb-xfixes0-dev python3 -y

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

  echo "${yellow}Installing NodeJS (Current)${reset}"
  curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash -
  sudo apt-get install nodejs -y

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
  sudo curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  echo "${yellow}Installing pnpm${reset}"
  sudo npm install -g pnpm

  echo "${yellow}Installing yarn${reset}"
  sudo npm install -g yarn

  . $dotfilesDirectory/update-vim.sh

  . $dotfilesDirectory/update-alacritty.sh

  . $dotfilesDirectory/update-starship.sh

  . $dotfilesDirectory/update-pagraphcontrol.sh

  . $dotfilesDirectory/update-fonts.sh

  . $dotfilesDirectory/update-cursor.sh
}

install_dotfiles
