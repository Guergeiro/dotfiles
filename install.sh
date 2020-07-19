#!/bin/bash

echo "Updating/Cleaning Packages"
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
    sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get dist-upgrade -y; sudo apt-get autoremove -y; sudo apt-get autoclean -y;
    sudo apt-get install build-dep vim -y

echo "Installing Git"

    sudo apt-get install git -y

echo "Cloning Git Repo"

    git clone --recurse-submodules -j8 https://github.com/Guergeiro/linux-how-to.git

echo "Building Vim from source"

    sudo make install -C linux-how-to/vim

echo "Installing Vim extras"

    sudo apt-get install vim-gtk -y


echo "Installing Deno"

    curl -fsSL https://deno.land/x/install/install.sh | sh
    sudo mv $HOME/.deno/bin/deno /usr/bin/


echo "Installing NodeJS (LTS)"

    curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs


echo "Installing Python3"

    sudo apt-get install python3 -y


echo "Installing OpenJDK (Headless)"

    sudo apt-get install default-jdk-headless -y


echo "Installing Yarn"

    sudo npm install -g yarn


echo "Installing TypeScript"

    sudo npm install -g typescript


echo "Installing Prettier"

    sudo npm install -g prettier


echo "Installing Docker"

    sudo apt-get install apt-transport-https ca-certificates gnupg-agent software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu$(lsb_release -cs)stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    sudo usermod -aG docker $USER

echo "Copying Vim/Bash Configs"

    cd linux-how-to/
    cp -r .vim/ $HOME/
    cp .bash_aliases $HOME/
    cp .vimrc $HOME/
    cd ..

echo "Installing NerdFonts"

    cd linux-how-to/
    nerd-fonts/install.sh
    cd ..

echo "Configuring CoC Vim"

    cd $HOME/.vim/pack/vendor/start/coc.nvim
    yarn
    cd $HOME

