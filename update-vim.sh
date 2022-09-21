#!/bin/sh

update_vim() {
  local yellow=`tput setaf 3`
  local reset=`tput sgr0`
  local currentDirectory=$(pwd)

  echo "${yellow}Updating vim${reset}"
  sudo apt-get purge vim* gvim* -y
  # https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source
  sudo apt-get install libncurses5-dev libgtk2.0-dev libatk1.0-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python2-dev \
    python3-dev ruby-dev lua5.2 liblua5.2-dev libperl-dev \
    libevent-dev ncurses-dev build-essential bison \
    cmake pkg-config libfreetype6-dev libfontconfig1-dev \
    libxcb-xfixes0-dev python3 -y
  command cd $vimDirectory
  git pull
  make distclean
  ./configure --with-features=huge \
              --enable-multibyte \
              --enable-rubyinterp=yes \
              --enable-python3interp=yes \
              --with-python3-config-dir=$(python3-config --configdir) \
              --enable-perlinterp=yes \
              --enable-luainterp=yes \
              --enable-cscope
  sudo make install

  echo "${yellow}Making vim default${reset}"
  sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
  sudo update-alternatives --set editor /usr/local/bin/vim
  sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
  sudo update-alternatives --set vi /usr/local/bin/vim

  command cd $currentDirectory
}

update_vim
