{ config, pkgs, ... } :

{ 
  programs.tmux = {
    enable = true;
    newSession = true;
    terminal = "screen-256color";
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    escapeTime = 0;

    extraTmuxConf = ''
      # enable mouse support
      set-option -g mouse on

      # more logical window splits
      unbind-key '%'
      unbind-key '"'
      bind-key '|' split-window -h -c "#{pane_current_path}"
      bind-key '\' split-window -v -c "#{pane_current_path}"

      unbind-key 'n'
      unbind-key 'p'
      bind-key 'C-l' last-window
      bind-key -r 'C-j' next-window
      bind-key -r 'C-k' previous-window

      bind-key -r 'h' select-pane -L
      bind-key -r 'j' select-pane -D
      bind-key -r 'k' select-pane -U
      bind-key -r 'l' select-pane -R

      # colors
      set-option -g pane-active-border-fg brightmagenta
      set-option -g pane-border-fg brightblack
      set-option -g display-panes-colour green
      set-option -g display-panes-active-colour brightred
      set-option -g clock-mode-colour brightwhite
      set-option -g mode-bg magenta
      set-option -g mode-fg brightwhite
      set-window-option -g window-status-bg black
      set-window-option -g window-status-fg brightgreen
      set-window-option -g window-status-current-bg black
      set-window-option -g window-status-current-fg brightwhite
      set-window-option -g window-status-bell-bg black
      set-window-option -g window-status-bell-fg brightred
      set-window-option -g window-status-activity-bg black
      set-window-option -g window-status-activity-fg brightred
      set -g status-bg black
      set -g status-fg brightmagenta
      set -g message-bg magenta
      set -g message-fg brightwhite
    '';
  };
}
