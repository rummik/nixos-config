{ config, pkgs, ... } :

{ 
  imports = [
    ../options/tmux.nix
  ];

  environment.systemPackages = with pkgs; [
    tmuxp
    tmuxPlugins.resurrect
  ];

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    escapeTime = 0;

    plugins = with pkgs.tmuxPlugins; [
      resurrect
      continuum
    ];

    theme.primaryColor = "green";

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

      bind-key -r '>' swap-window -t +1
      bind-key -r '<' swap-window -t -1

      # status line
      set -g status-right ' #(echo ''${SSH_CONNECTION%%%% *}) '
      set -g status-left '#H  '

      # Pane resize options
      set -g main-pane-width 127
      set -g main-pane-height 45

      # resurrect options
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-processes 'mosh ssh "~yarn watch" "~yarn watch->yarn watch"'

      # continuum options
      set -g @continuum-save-interval '15'
      set -g @continuum-restore 'on'
    '';
  };
}
