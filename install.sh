#!/bin/sh

yellow=`tput setaf 3`
reset=`tput sgr0`

echo "${yellow}Updating/Cleaning Packages${reset}"
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
    sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get dist-upgrade -y; sudo apt-get autoremove -y; sudo apt-get autoclean -y;
    sudo apt-get build-dep vim -y

echo "${yellow}Installing Git${reset}"

    sudo apt-get install git -y

echo "${yellow}Cloning Git Repo${reset}"

    if [ "$1" = "-with-fonts" ]; then
        git clone --recurse-submodules -j8 https://github.com/Guergeiro/dotfiles.git
    else
        git clone --recurse-submodules=vim -j8 https://github.com/Guergeiro/dotfiles.git
    fi

echo "${yellow}Building Vim from source${reset}"

    cd dotfiles/vim/
    # Get new tags from remote
    git fetch --tags

    # Get latest tag name
    latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)

    # Checkout latest tag
    git checkout $latestTag

    ./configure
    sudo make install
    cd ../../

echo "${yellow}Installing Vim extras${reset}"

    sudo apt-get install vim-gtk -y

echo "${yellow}Installing Zip${reset}"

    sudo apt-get install zip -y

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

echo "${yellow}Installing Yarn${reset}"

    sudo npm install -g yarn

echo "${yellow}Installing TypeScript${reset}"

    sudo npm install -g typescript

echo "${yellow}Installing Prettier${reset}"

    sudo npm install -g prettier

echo "${yellow}Copying Vim/Bash Configs${reset}"

    cd dotfiles/
    cp .bashrc $HOME/
    cp .bash_aliases $HOME/
    cp .vimrc $HOME/
    cp -r .vim/ $HOME/
    cd ..

if [ "$1" = "-with-fonts" ]; then
    echo "${yellow}Installing NerdFonts${reset}"

        cd dotfiles/
        nerd-fonts/install.sh
        cd ..
fi

echo "${yellow}Removing extra files${reset}"

    sudo /usr/bin/rm -rf dotfiles/
