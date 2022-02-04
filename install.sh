#!/bin/sh

yellow=`tput setaf 3`
reset=`tput sgr0`

dotfilesDirectory=$HOME/Documents/guergeiro/dotfiles
vimDirectory=$HOME/Documents/vim/vim
srceryterminalDirectory=$HOME/Documents/srcery-colors/srcery-terminal
alacrittyDirectory=$HOME/Documents/alacritty/alacritty
nerdfontsDirectory=$HOME/Documents/ryanoasis/nerd-fonts

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
if [ "$1" = "-with-fonts" ]; then
  git clone https://github.com/ryanoasis/nerd-fonts.git $nerdfontsDirectory
fi

echo "${yellow}Installing extra packages${reset}"
# https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source
sudo apt-get install libncurses5-dev libgtk2.0-dev libatk1.0-dev \
  libcairo2-dev libx11-dev libxpm-dev libxt-dev python2-dev \
  python3-dev ruby-dev lua5.2 liblua5.2-dev libperl-dev -y

sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev \
  libxcb-xfixes0-dev python3

echo "${yellow}Installing Rust${reset}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustup override set stable
rustup update stable

echo "${yellow}Installing Zip and Rar${reset}"
sudo apt-get install zip rar gzip -y

echo "${yellow}Building Vim from source${reset}"
sudo apt-get purge vim vim-runtime gvim -y
cd $vimDirectory/
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-python3interp=yes \
            --with-python3-config-dir=$(python3-config --configdir) \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-cscope
sudo make install
cd $HOME

echo "${yellow}Building Alacritty from source${reset}"
cd $alacrittyDirectory
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
sudo cp extra/completions/alacritty.bash /etc/bash_completion.d/

echo "${yellow}Installing Tmux${reset}"
sudo apt-get install tmux -y
git clone https://github.com/imomaliev/tmux-bash-completion.git $HOME/Documents/imomaliev/tmux-bash-completion
sudo cp $HOME/Documents/imomaliev/tmux-bash-completion/completions/tmux /etc/bash_completion.d/
rm -rf $HOME/Documents/imomaliev/tmux-bash-completion
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "${yellow}Installing Deno${reset}"
curl -fsSL https://deno.land/x/install/install.sh | sh
sudo mv $HOME/.deno/bin/deno /usr/bin/
deno completions > deno
sudo mv deno /etc/bash_completion.d/
rm deno

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

echo "${yellow}Installing starship shell${reset}"
curl -fsSL https://starship.rs/install.sh | bash

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

echo "${yellow}Removing Vim/Bash Default Configs${reset}"
rm -rf $HOME/.bashrc
rm -rf $HOME/.bash_aliases
rm -rf $HOME/.bash_functions
rm -rf $HOME/.bash_starship
rm -rf $HOME/.inputrc
rm -rf $HOME/.gitconfig
rm -rf $HOME/.config/starship.toml
rm -rf $HOME/.vimrc
rm -rf $HOME/.vim

echo "${yellow}General configs${reset}"
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
sudo update-alternatives --set editor /usr/local/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
sudo update-alternatives --set vi /usr/local/bin/vim

if [ "$1" = "-with-fonts" ]; then
  echo "${yellow}Installing NerdFonts${reset}"
  cd $nerdfontsDirectory/
  ./install.sh
  cd $HOME
fi
