#!/bin/sh

install_dotfiles() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`

  local dotfilesDirectory=$HOME/Documents/guergeiro/dotfiles
  local vimDirectory=$HOME/Documents/vim/vim
  local srceryterminalDirectory=$HOME/Documents/srcery-colors/srcery-terminal
  local alacrittyDirectory=$HOME/Documents/alacritty/alacritty
  local tmuxDirectory=$HOME/Documents/tmux/tmux
  local nerdfontsDirectory=$HOME/Documents/ryanoasis/nerd-fonts

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
  git clone https://github.com/alacritty/alacritty.git $alacrittyDirectory
  git clone https://github.com/tmux/tmux.git $tmuxDirectory
  if [ "$1" = "-with-fonts" ]; then
    git clone https://github.com/ryanoasis/nerd-fonts.git $nerdfontsDirectory
  fi

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
  source $dotfilesDirectory/update-tmux.sh

  echo "${yellow}Installing Rust${reset}"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source $HOME/.cargo/env
  rustup override set stable
  source $dotfilesDirectory/update-rust.sh

  echo "${yellow}Installing Deno${reset}"
  curl -fsSL https://deno.land/x/install/install.sh | sudo DENO_INSTALL=/usr/bin sh
  source $dotfilesDirectory/update-deno.sh

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

  echo "${yellow}Installing stow${reset}"
  sudo apt-get install stow -y

  echo "${yellow}Installing Docker${reset}"
  sudo groupadd docker
  sudo usermod -aG docker $USER
  sudo apt-get purge docker* containerd runc
  curl -fsSL https://get.docker.com | sh

  echo "${yellow}Installing Docker Compose${reset}"
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo curl \
      -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose \
      -o /etc/bash_completion.d/docker-compose

  echo "${yellow}Installing pnpm${reset}"
  sudo npx pnpm add -g pnpm

  source $dotfilesDirectory/update-vim.sh

  source $dotfilesDirectory/update-alacritty.sh

  source $dotfilesDirectory/update-starship.sh

  source $dotfilesDirectory/update-stow.sh

  if [ "$1" = "-with-fonts" ]; then
    source $dotfilesDirectory/update-fonts.sh
  fi

  echo "${yellow}Appending global variables to .bashrc${reset}"
  echo "export dotfilesDirectory=$dotfilesDirectory" >> $HOME/.bashrc
  echo "export vimDirectory=$vimDirectory" >> $HOME/.bashrc
  echo "export srceryterminalDirectory=$srceryterminalDirectory" >> $HOME/.bashrc
  echo "export alacrittyDirectory=$alacrittyDirectory" >> $HOME/.bashrc
  echo "export tmuxDirectory=$tmuxDirectory" >> $HOME/.bashrc
  echo "export nerdfontsDirectory=$nerdfontsDirectory" >> $HOME/.bashrc
}

install_dotfiles
