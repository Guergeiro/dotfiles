#!/bin/bash

green=`tput setaf 3`
reset=`tput sgr0`

echo "${yellow}Updating/Cleaning Packages${reset}"
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
    sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get dist-upgrade -y; sudo apt-get autoremove -y; sudo apt-get autoclean -y;
    sudo apt-get build-dep vim -y

echo "${yellow}Installing Git${reset}"

    sudo apt-get install git -y

echo "${yellow}Cloning Git Repo"

    git clone --recurse-submodules -j8 https://github.com/Guergeiro/linux-how-to.git

echo "${yellow}Building Vim from source${reset}"

    sudo make install -C linux-how-to/vim

echo "${yellow}Installing Vim extras${reset}"

    sudo apt-get install vim-gtk -y


echo "${yellow}Installing Deno${reset}"

    curl -fsSL https://deno.land/x/install/install.sh | sh
    sudo mv $HOME/.deno/bin/deno /usr/bin/


echo "${yellow}Installing NodeJS (LTS)${reset}"

    curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs


echo "${yellow}Installing Python3${reset}"

    sudo apt-get install python3 -y


echo "${yellow}Installing OpenJDK (Headless)${reset}"

    sudo apt-get install default-jdk-headless -y


echo "${yellow}Installing Yarn${reset}"

    sudo npm install -g yarn


echo "${yellow}Installing TypeScript${reset}"

    sudo npm install -g typescript


echo "${yellow}Installing Prettier${reset}"

    sudo npm install -g prettier


echo "${yellow}Installing Docker${reset}"

    sudo apt-get install apt-transport-https ca-certificates gnupg-agent software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    sudo usermod -aG docker $USER

echo "${yellow}Copying Vim/Bash Configs${reset}"

    cd linux-how-to/
    cp -r .vim/ $HOME/
    cp .bash_aliases $HOME/
    cp .vimrc $HOME/
    cd ..

echo "${yellow}Installing NerdFonts${reset}"

    cd linux-how-to/
    nerd-fonts/install.sh
    cd ..

echo "${yellow}Configuring CoC Vim${reset}"

    cd $HOME/.vim/pack/vendor/start/coc.nvim
    yarn
    cd $HOME
