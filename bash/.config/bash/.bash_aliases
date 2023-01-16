#!/bin/bash
# You remember Vi? It's just faster to type
alias vi="vim";
# Force tmux UTF-8
alias tmux="tmux -u"
# Sometimes I forget I'm not in VIM, but still want to quit :>
alias :q="exit";
# Fuck Python2... Sorry :(
alias python="python3"; alias pip="pip3";
# Security stuff
alias del="trash";
alias rm="echo Use \"del\", or the full path i.e. \"/bin/rm\"";
alias mv="mv -i";
alias cp="cp -i";
alias ln="ln -i";
# Recursively create directories
alias mkdir="mkdir -pv";
# I don't know the name of every explorer
if [ "$(command uname -r)" = *"microsoft"* ]; then
    alias explorer="explorer.exe";
elif [ "$(command lsb_release -is)" = "Linuxmint" ]; then
    alias explorer="thunar";
else
    alias explorer="nautilus";
fi
# Some more ls aliases
alias ll="ls -alhF"; alias la="ls -hA"; alias l="ls -CF";
# Ripgrep rules for me!
alias grep="rg --hidden";
# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls --color=auto";

    alias grep="rg --color=auto";
    alias fgrep="rg -F --color=auto";
    alias egrep="rg -E --color=auto";
fi
# Screenkey defaults
alias screenkey="screenkey --position fixed --geometry 70%x5%+15%-1 &";
# Create a new copy/paste command that allows too feed/read content directly to/from xclip
alias copy="xclip -i -selection clipboard"
alias paste="xclip -o -selection clipboard"
# Some of my sensible defaults for curl. I can use normal curl if I need diffent stuff
alias GET="curl --include --request GET --header \"Content-Type: application/json \"";
alias POST="curl --include --request POST --header \"Content-Type: application/json \"";
alias PUT="curl --include --request PUT --header \"Content-Type: application/json \"";
alias DELETE="curl --include --request DELETE --header \"Content-Type: application/json \"";
alias PATCH="curl --include --request PATCH --header \"Content-Type: application/json \"";
# Bat is awesome
alias cat="batcat";
alias wget="wget --hsts-file=\"$XDG_CACHE_HOME/wget-hsts\"";
alias pnpx="pnpm dlx --silent"
