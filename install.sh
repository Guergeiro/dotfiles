#!/bin/bash

echo -e "\nUpdating/Cleaning Packages"
sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get dist-upgrade -y; sudo apt-get autoremove -y; sudo apt-get autoclean -y;

echo -e "\nInstalling Git"
sudo apt-get install git -y

echo -e "\nInstalling Vim and extras"
sudo apt-get install vim vim-gtk -y

echo -e "\nInstalling Deno"
curl -fsSL https://deno.land/x/install/install.sh | sh
sudo mv $HOME/.deno/bin/deno /usr/bin/

echo -e "\nInstalling NodeJS (LTS)"
curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

echo -e "\bInstalling Python3"
sudo apt-get install python3 -y

echo -e "\nInstalling OpenJDK (Headless)"
sudo apt-get install default-jdk-headless -y

echo -e "\nInstalling Yarn"
sudo npm install -g yarn

echo -e "\nInstalling TypeScript"
sudo npm install -g typescript

echo -e "\nInstalling Prettier"
sudo npm install -g prettier

echo -e "\nInstalling Docker"
sudo apt-get install apt-transport-https ca-certificates gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu$(lsb_release -cs)stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo usermod -aG docker $USER

echo -e "\nCloning Git Repo"
git clone --recurse-submodules -j8 https://github.com/Guergeiro/linux-how-to.git

echo -e "\nCopying Vim/Bash Configs"
cd linux-how-to/
cp -r .vim/ $HOME/
cp .bash_aliases $HOME/
cp .vimrc $HOME/
cd ..

echo -e "\nInstalling NerdFonts"
cd linux-how-to/
nerd-fonts/install.sh
cd ..

echo -e "\nConfiguring CoC Vim"
cd $HOME/.vim/pack/vendor/start/coc.nvim
yarn
cd $HOME
