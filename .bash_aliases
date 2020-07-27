# Just update/clean everything
alias update='sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get dist-upgrade -y; sudo apt-get autoremove -y; sudo apt-get autoclean -y;';
# You remember Vi? It's just faster to type
alias vi='vim';
# Fuck Python2... Sorry :(
alias python='python3';
alias pip='pip3';
# I'm lazy :>
alias ..='cd ..';
# Some more ls aliases
alias ll='ls -alF';
alias la='ls -A';
alias l='ls -CF';
# Ripgrep rules for me!
alias grep='rg';
alias frep='rg -F';
alias erep='rg -E';
# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='rg --color=auto'
    alias fgrep='rg -F --color=auto'
    alias egrep='rg -E --color=auto'
fi
