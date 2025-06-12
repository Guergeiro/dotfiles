{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "tmux-256color";
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
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-vim 'session'";
      }
      tmuxPlugins.yank
    ];
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
    '';
  };
}
