{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util, nix-homebrew, homebrew-core, homebrew-cask, ... }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
          pkgs.alacritty
          pkgs.alacritty-theme
          pkgs.bashInteractive
          pkgs.bash-completion
          pkgs.coreutils
          pkgs.git
          pkgs.librewolf
          pkgs.openssh
        ];
      users = {
        users."my-user" = {
          shell = pkgs.bashInteractive;
          packages = [
            pkgs.aerospace
            pkgs.bat
            pkgs.deno
            pkgs.curl
            pkgs.direnv
            pkgs.docker
            pkgs.gcc
            pkgs.neovim
            pkgs.nix-direnv
            pkgs.nodejs_22
            pkgs.ripgrep
            pkgs.starship
            pkgs.stow
            pkgs.gnutar
            pkgs.tmux
            pkgs.tmuxPlugins.dracula
            pkgs.tmuxPlugins.resurrect
            pkgs.tmuxPlugins.yank
            pkgs.trash-cli
          ];
        };
      };
      environment.shells = [
        pkgs.bashInteractive
      ];

      environment.shellAliases = {
        # You remember Vi? It's just faster to type
        vi = "${pkgs.neovim}/bin/nvim";
        vim = "${pkgs.neovim}/bin/nvim";
        # Force tmux UTF-8
        tmux="${pkgs.tmux}/bin/tmux -u";
        # Sometimes I forget I'm not in VIM, but still want to quit :>
        ":q"="exit";
        # Fuck Python2... Sorry :(
        python="python3"; pip="pip3";
        # Security stuff
        del="${pkgs.trash-cli}/bin/trash";
        rm="${pkgs.coreutils}/bin/echo Use \"del\", or the full path i.e. \"/bin/rm\"";
        mv="${pkgs.coreutils}/bin/mv -i";
        cp="${pkgs.coreutils}/bin/cp -i";
        ln="${pkgs.coreutils}/bin/ln -i";
        # Recursively create directories
        mkdir="${pkgs.coreutils}/bin/mkdir -pv";

        # Some more ls aliases
        ll="${pkgs.coreutils}/bin/ls -alhF";
        la="${pkgs.coreutils}/bin/ls -hA";
        l="${pkgs.coreutils}/bin/ls -CF";
        ls="${pkgs.coreutils}/bin/ls --color=auto";

        # Ripgrep rules for me!
        grep="${pkgs.ripgrep}/bin/rg --hidden --color=auto";
        fgrep="${pkgs.ripgrep}/bin/rg -F --color=auto";
        egrep="${pkgs.ripgrep}/bin/rg -E --color=auto";

        # Create a new copy/paste command that allows too feed/read content directly to/from xclip
        copy="xclip -i -selection clipboard";
        paste="xclip -o -selection clipboard";
        # Bat is awesome
        cat="${pkgs.bat}/bin/bat";
      };

      homebrew = {
        enable = true;
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      security.pam.services.sudo_local = {
        reattach = true;
        touchIdAuth = true;
      };

      # Necessary for using flakes on this system.
      nix = {
        settings = {
          experimental-features = "nix-command flakes";
        };
        optimise.automatic = true;
        gc = {
          automatic = true;
          options = "--delete-older-than 10d";
        };
      };

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      system.defaults = {
        NSGlobalDomain = {
          AppleICUForce24HourTime = true;
          AppleInterfaceStyle = "Dark";
          AppleInterfaceStyleSwitchesAutomatically = true;
          AppleMeasurementUnits = "Centimeters";
          AppleMetricUnits = 1;
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          "com.apple.keyboard.fnState" = true;
          "com.apple.trackpad.forceClick" = true;
          "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
        };
        trackpad = {
          TrackpadRightClick = true;
        };
        hitoolbox.AppleFnUsageType = "Do Nothing";
        controlcenter.BatteryShowPercentage = true;
        dock = {
          autohide = true;
          autohide-delay = 0.1;
          launchanim = false;
          mineffect = "scale";
          tilesize = 1;
          wvous-bl-corner = 1;
          wvous-br-corner = 4;
          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
        };
        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          ShowPathbar = true;
          FXPreferredViewStyle = "clmv";
          QuitMenuItem = true;
        };
        loginwindow.GuestEnabled = false;
        menuExtraClock.Show24Hour = true;
      };

      system.keyboard = {
        enableKeyMapping = true;
        nonUS.remapTilde = true;
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      fonts.packages = [
        pkgs.nerd-fonts.fantasque-sans-mono
      ];

      programs = {
        zsh = {
          enable = true;
          shellInit = "${pkgs.bashInteractive}/bin/bash && exit";
        };
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        bash = {
          enable = true;
          completion.enable = true;
          interactiveShellInit = ''
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
if [ -z "''${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;''${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *)
    ;;
esac

# Removes the need of using cd
shopt -s autocd
# Automatically tries it's best to correct misspell
shopt -s cdspell

# Make sure correct ENV variables are set
export XDG_DATA_HOME=''${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=''${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=''${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_STATE_HOME=''${XDG_STATE_HOME:="$HOME/.local/state"}

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
	if [[ -n "''${go_bin_path}" ]]; then
		local abs_go_bin_path="$(readlink -f "''${go_bin_path}")"

		export GOROOT="$(dirname "$(dirname "''${abs_go_bin_path}")")"

		export GOPATH="$(dirname "''${GOROOT}")/packages"

		__path_update "$GOPATH/bin"
fi
}
__asdf_golang

# Rust
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
__path_update "$CARGO_HOME/bin"

export MANPAGER="sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

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
          '';
        };
        tmux = {
          enable = true;
          extraConfig = ''
unbind C-a
unbind C-b
unbind C-w
set-option -g prefix C-a
bind-key C-a send-prefix

# Windows
bind-key l next-window
bind-key h previous-window
bind-key n new-window -c "#{pane_current_path}"
bind-key % split-window -h -c "#{pane_current_path}"
bind-key '"' split-window -c "#{pane_current_path}"

# Panes
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind-key -n C-w if-shell "$is_vim" "send-keys C-w" "switch-client -T VIMWINDOWS"
bind-key -T VIMWINDOWS h select-pane -L
bind-key -T VIMWINDOWS j select-pane -D
bind-key -T VIMWINDOWS k select-pane -U
bind-key -T VIMWINDOWS l select-pane -R
bind-key -T VIMWINDOWS s split-window -c "#{pane_current_path}"
bind-key -T VIMWINDOWS v split-window -h -c "#{pane_current_path}"
bind-key -T VIMWINDOWS c kill-pane

# address vim mode switching delay (http://superuser.com/a/252717/65504)
set -s escape-time 0

# increase scrollback buffer size
set -g history-limit 50000

# tmux messages are displayed for 4 seconds
set -g display-time 4000

# upgrade $TERM
set -g default-terminal "tmux-256color"
# set -ag terminal-overrides ",xterm-256color:RGB"

# focus events enabled for terminals that support them
set -g focus-events on

# super useful when using "grouped sessions" and multi-monitor setup
set -g aggressive-resize on

# No bells at all
set -g bell-action none

# No bells at all
set -g bell-action none

# Keep windows around after they exit
set -g remain-on-exit off

# Mouse support
set -g mouse on

# Vi mode
set-window-option -g mode-keys vi
bind-key -T copy-mode-vi v send-keys -X begin-selection

# List of plugins
set -g @resurrect-strategy-vim 'session'

set -g @dracula-show-powerline true
set -g @dracula-show-flags true
set -g @dracula-show-left-icon session
set -g @dracula-plugins "time"
run '${pkgs.tmuxPlugins.dracula}/share/tmux-plugins/dracula/dracula.tmux'
run '${pkgs.tmuxPlugins.dracula}/share/tmux-plugins/yank/yank.tmux'
run '${pkgs.tmuxPlugins.dracula}/share/tmux-plugins/resurrect/resurrect.tmux'
          '';
        };
      };

      services = {
        aerospace = {
          enable = true;
          settings = {
            mode.main.binding = {
              alt-1 = "workspace 1";
              alt-2 = "workspace 2";
              alt-3 = "workspace 3";
              alt-4 = "workspace 4";
              alt-5 = "workspace 5";
              alt-6 = "workspace 6";
              alt-7 = "workspace 7";
              alt-8 = "workspace 8";
              alt-9 = "workspace 9";

              alt-shift-1 = "move-node-to-workspace 1";
              alt-shift-2 = "move-node-to-workspace 2";
              alt-shift-3 = "move-node-to-workspace 3";
              alt-shift-4 = "move-node-to-workspace 4";
              alt-shift-5 = "move-node-to-workspace 5";
              alt-shift-6 = "move-node-to-workspace 6";
              alt-shift-7 = "move-node-to-workspace 7";
              alt-shift-8 = "move-node-to-workspace 8";
              alt-shift-9 = "move-node-to-workspace 9";

              alt-shift-r = "reload-config";
              alt-f = "layout floating tiling";
              f11 = "macos-native-fullscreen";
            };
          };
        };
      };
    };

  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .macbook
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [
        ({ config, ... }: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
        configuration
        mac-app-util.darwinModules.default
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "my-user";

            # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
      ];
    };
  };

}
