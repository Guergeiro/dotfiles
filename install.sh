#!/bin/bash

echo "Updating/Cleaning Packages"
sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get dist-upgrade -y; sudo apt-get autoremove -y; sudo apt-get autoclean -y;

echo "Installing Git"
{
    sudo apt-get install git -y
} &> /dev/null

echo "Installing Vim and extras"
{
    sudo apt-get install vim vim-gtk -y
} &> /dev/null

echo "Installing Deno"
{
    curl -fsSL https://deno.land/x/install/install.sh | sh
    sudo mv $HOME/.deno/bin/deno /usr/bin/
} &> /dev/null

echo "Installing NodeJS (LTS)"
{
    curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
} &> /dev/null

echo "Installing Python3"
{
    sudo apt-get install python3 -y
} &> /dev/null

echo "Installing OpenJDK (Headless)"
{
    sudo apt-get install default-jdk-headless -y
} &> /dev/null

echo "Installing Yarn"
{
    sudo npm install -g yarn
} &> /dev/null

echo "Installing TypeScript"
{
    sudo npm install -g typescript
} &> /dev/null

echo "Installing Prettier"
{
    sudo npm install -g prettier
} &> /dev/null

echo "Installing Docker"
{
    sudo apt-get install apt-transport-https ca-certificates gnupg-agent software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu$(lsb_release -cs)stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    sudo usermod -aG docker $USER
} &> /dev/null

echo "Cloning Git Repo"
{
    git clone --recurse-submodules -j8 https://github.com/Guergeiro/linux-how-to.git
} &> /dev/null

echo "Copying Vim/Bash Configs"
{
    cd linux-how-to/
    cp -r .vim/ $HOME/
    cp .bash_aliases $HOME/
    cp .vimrc $HOME/
    cd ..
} &> /dev/null

echo "Installing NerdFonts"
{
    cd linux-how-to/
    nerd-fonts/install.sh
    cd ..
} &> /dev/null

echo "Configuring CoC Vim"
{
    cd $HOME/.vim/pack/vendor/start/coc.nvim
    yarn
    cd $HOME
} &> /dev/null
