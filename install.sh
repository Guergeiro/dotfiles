#!/bin/bash

echo -e "\nUpdating/Cleaning Packages"
{
    sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get dist-upgrade -y; sudo apt-get autoremove -y; sudo apt-get autoclean -y;
} &> /dev/null

echo -e "\nInstalling Git"
{
    sudo apt-get install git -y
} &> /dev/null

echo -e "\nInstalling Vim and extras"
{
    sudo apt-get install vim vim-gtk -y
} &> /dev/null

echo -e "\nInstalling Deno"
{
    curl -fsSL https://deno.land/x/install/install.sh | sh
    sudo mv $HOME/.deno/bin/deno /usr/bin/
} &> /dev/null

echo -e "\nInstalling NodeJS (LTS)"
{
    curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
} &> /dev/null

echo -e "\bInstalling Python3"
{
    sudo apt-get install python3 -y
} &> /dev/null

echo -e "\nInstalling OpenJDK (Headless)"
{
    sudo apt-get install default-jdk-headless -y
} &> /dev/null

echo -e "\nInstalling Yarn"
{
    sudo npm install -g yarn
} &> /dev/null

echo -e "\nInstalling TypeScript"
{
    sudo npm install -g typescript
} &> /dev/null

echo -e "\nInstalling Prettier"
{
    sudo npm install -g prettier
} &> /dev/null

echo -e "\nInstalling Docker"
{
    sudo apt-get install apt-transport-https ca-certificates gnupg-agent software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu$(lsb_release -cs)stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    sudo usermod -aG docker $USER
} &> /dev/null

echo -e "\nCloning Git Repo"
{
    git clone --recurse-submodules -j8 https://github.com/Guergeiro/linux-how-to.git
} &> /dev/null

echo -e "\nCopying Vim/Bash Configs"
{
    cd linux-how-to/
    cp -r .vim/ $HOME/
    cp .bash_aliases $HOME/
    cp .vimrc $HOME/
    cd ..
} &> /dev/null

echo -e "\nInstalling NerdFonts"
{
    cd linux-how-to/
    nerd-fonts/install.sh
    cd ..
} &> /dev/null

echo -e "\nConfiguring CoC Vim"
{
    cd $HOME/.vim/pack/vendor/start/coc.nvim
    yarn
    cd $HOME
} &> /dev/null
