{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "tmux-256color";
    shell = "${pkgs.bashInteractive}/bin/bash";
    sensibleOnTop = false;
    mouse = true;
    historyLimit = 50000;
    escapeTime = 0;
    keyMode = "vi";
    aggressiveResize = true;
    secureSocket = false;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.dracula;
        extraConfig = ''
          set -g @dracula-show-powerline true
          set -g @dracula-show-flags true
          set -g @dracula-show-left-icon session
          set -g @dracula-plugins "time"
        '';
      }
      tmuxPlugins.yank
    ];
    extraConfig = ''
set-option -g update-environment "PATH"
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

# tmux messages are displayed for 4 seconds
set -g display-time 4000

# focus events enabled for terminals that support them
set -g focus-events on

# No bells at all
set -g bell-action none

# No bells at all
set -g bell-action none

# Keep windows around after they exit
set -g remain-on-exit off

# Vi mode
set-window-option -g mode-keys vi
bind-key -T copy-mode-vi v send-keys -X begin-selection
    '';
  };
}
