{ config, pkgs, ... } :

{ 
  imports = [
    ../options/tmux.nix
  ];

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
    '';
  };
}
