# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *)
    ;;
esac

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Removes the need of using cd
shopt -s autocd
# Automatically tries it's best to correct misspell
shopt -s cdspell

# Make sure correct ENV variables are set
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}

export USERXSESSION="$XDG_CACHE_HOME/X11/xsession"
export USERXSESSIONRC="$XDG_CACHE_HOME/X11/xsessionrc"
export ALTUSERXSESSION="$XDG_CACHE_HOME/X11/Xsession"
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"
export SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# Function to automatically update PATH if not exists
function __path_update() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

# Gradle
export GRADLE_HOME="$XDG_DATA_HOME/gradle"
__path_update "$GRADLE_HOME/bin"
export GRADLE_USER_HOME="$XDG_CONFIG_HOME/gradle"
__path_update "$GRADLE_USER_HOME"

# npm user global packages
__path_update "$XDG_DATA_HOME/npm/bin"

# pnpm
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
__path_update "$PNPM_HOME"
# pnpm end

# Deno
export DENO_INSTALL="$XDG_DATA_HOME/deno"
__path_update "$DENO_INSTALL/bin"

# Neovim
export NEOVIM_HOME="$XDG_DATA_HOME/neovim"
__path_update "$NEOVIM_HOME/nvim-linux-x86_64/bin"

# Alacritty
export ALACRITTY_HOME="$XDG_DATA_HOME/alacritty"
__path_update "$ALACRITTY_HOME/bin"

# Tmux
export TMUX_HOME="$XDG_DATA_HOME/tmux"
__path_update "$TMUX_HOME/bin"

# Starship
export STARSHIP_HOME="$XDG_DATA_HOME/starship"
__path_update "$STARSHIP_HOME"

# Pip
export PIP_HOME="$XDG_DATA_HOME/pip"
__path_update "$PIP_HOME/bin"

# Go
function __asdf_golang() {
	local go_bin_path="$(asdf which go 2>/dev/null)"
	if [[ -n "${go_bin_path}" ]]; then
		local abs_go_bin_path="$(readlink -f "${go_bin_path}")"

		export GOROOT="$(dirname "$(dirname "${abs_go_bin_path}")")"

		export GOPATH="$(dirname "${GOROOT}")/packages"

		__path_update "$GOPATH/bin"
fi
}
__asdf_golang

# Rust
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
__path_update "$CARGO_HOME/bin"

export MANPAGER="sh -c 'col -bx | batcat -l man -p'"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f "$XDG_CONFIG_HOME/bash/.bash_aliases" ]; then
  . "$XDG_CONFIG_HOME/bash/.bash_aliases"
fi

# Functions definitions
if [ -f "$XDG_CONFIG_HOME/bash/.bash_functions" ]; then
  . "$XDG_CONFIG_HOME/bash/.bash_functions"
fi

# Tmux definitions
if [ -f "$XDG_CONFIG_HOME/tmux/.bash_functions" ]; then
  . "$XDG_CONFIG_HOME/tmux/.bash_functions"
fi

# Starship definitions
if [ -f "$XDG_CONFIG_HOME/starship/.bash_functions" ]; then
  . "$XDG_CONFIG_HOME/starship/.bash_functions"
fi

# Docker definitions
if [ -f "$XDG_CONFIG_HOME/docker/.bash_functions" ]; then
  . "$XDG_CONFIG_HOME/docker/.bash_functions"
fi

# Private work scripts
if [ -f "$XDG_CONFIG_HOME/dotfiles-work/.bashrc" ]; then
  . "$XDG_CONFIG_HOME/dotfiles-work/.bashrc"
fi

export dotfilesDirectory="$HOME/Documents/guergeiro/dotfiles"
export notesDirectory="$HOME/Brain"
