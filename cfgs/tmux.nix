{ config, pkgs, ... } :

{ 
  imports = [
    ../options/tmux.nix
  ];

  environment.systemPackages = with pkgs; [
    tmuxp
  ];

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    escapeTime = 0;

    plugins = with pkgs.tmuxPlugins; [
      (resurrect.overrideAttrs (oldAttrs: rec {
        patches = [
          (pkgs.fetchpatch {
            url = "https://github.com/tmux-plugins/tmux-resurrect/commit/edd8132befb336b71190f55498dccc1772a8a893.patch";
            sha256 = "0px48gn5ja4z8mkhlm6b545r72rrqjp8wqnf642kh3r4walahy7j";
          })

          (pkgs.fetchpatch {
            url = "https://github.com/tmux-plugins/tmux-resurrect/commit/55536f8685d7fe96459fdd09a29a6fb01f0c8a80.patch";
            sha256 = "13sq0xa3z2msq0ldvff3qdfn217g7c2vc90py45vb8lg91p5r735";
          })
        ];
      }))

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
      set -g @resurrect-processes 'mosh ssh ~nvim "~yarn watch"'
      set -g @resurrect-save-command-strategy 'cmdline'
      #set -g @resurrect-strategy-nvim 'session'
      #set -g @resurrect-save-shell-history 'off'

      # continuum options
      set -g @continuum-save-interval '15'
      set -g @continuum-restore 'on'
    '';
  };
}
