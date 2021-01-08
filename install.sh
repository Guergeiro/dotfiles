#!/bin/sh

yellow=`tput setaf 3`
reset=`tput sgr0`

echo "${yellow}Updating/Cleaning Packages${reset}"
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y

echo "${yellow}Installing Git${reset}"
sudo apt-get install git -y

echo "${yellow}Cloning Git Repos${reset}"
git clone https://github.com/Guergeiro/dotfiles.git
git clone https://github.com/vim/vim.git
if [ "$1" = "-with-fonts" ]; then
  git clone https://github.com/ryanoasis/nerd-fonts.git
fi

echo "${yellow}Installing extra packages${reset}"
# https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source
sudo apt-get install libncurses5-dev libgtk2.0-dev libatk1.0-dev \
  libcairo2-dev libx11-dev libxpm-dev libxt-dev python2-dev \
  python3-dev ruby-dev lua5.2 liblua5.2-dev libperl-dev checkinstall -y

sudo apt-get purge vim vim-runtime gvim -y

echo "${yellow}Building Vim from source${reset}"
cd vim/
./configure --with-features=huge --with-python3-config-dir=$(python3-config --configdir) --enable-python3interp=yes
sudo checkinstall
cd ..

echo "${yellow}Installing Zip and Rar${reset}"
sudo apt-get install zip rar -y


echo "${yellow}Installing Deno${reset}"
curl -fsSL https://deno.land/x/install/install.sh | sh
sudo mv $HOME/.deno/bin/deno /usr/bin/

echo "${yellow}Installing NodeJS (LTS)${reset}"
curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install nodejs -y

echo "${yellow}Installing Python3${reset}"
sudo apt-get install python3 -y

echo "${yellow}Installing OpenJDK (Headless)${reset}"
sudo apt-get install default-jdk-headless -y

echo "${yellow}Installing RipGrep${reset}"
sudo apt-get install ripgrep -y

echo "${yellow}Installing Trash CLI${reset}"
sudo apt-get install trash-cli -y

echo "${yellow}Installing XCLIP${reset}"
sudo apt-get install xclip -y

echo "${yellow}Installing Yarn${reset}"
sudo npm install -g yarn

echo "${yellow}Installing TypeScript${reset}"
sudo yarn global add typescript

echo "${yellow}Installing Prettier${reset}"
sudo yarn global add prettier

echo "${yellow}Copying Vim/Bash Configs${reset}"
cd dotfiles/
cp .bashrc $HOME/
cp .bash_aliases $HOME/
cp .bash_functions $HOME/
cp .vimrc $HOME/
cp -r .vim/ $HOME/
cd ..

echo "${yellow}General configs${reset}"
git config --global core.editor vim
git config --global user.name Breno Salles
git config --global user.email git@brenosalles.com
git config --global merge.tool vimdiff
git config --global mergetool.keepBackup false
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
sudo update-alternatives --set editor /usr/local/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
sudo update-alternatives --set vi /usr/local/bin/vim

if [ "$1" = "-with-fonts" ]; then
  echo "${yellow}Installing NerdFonts${reset}"
  cd nerdfonts/
  ./install.sh
  cd ..
fi
