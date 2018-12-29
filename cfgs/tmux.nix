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
          # cmdline strategy
          (pkgs.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/tmux-plugins/tmux-resurrect/pull/283.patch";
            sha256 = "05d1a5642rx8b2b0fxy55sjha8hf4ik6bwdl754hzawayh7jcy9d";
          })

          # mosh-client strategy
          (pkgs.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/tmux-plugins/tmux-resurrect/pull/284.patch";
            sha256 = "1byhbi53dn1zglymva1h98zfw0m57nfravbv6pgppl7vvyw6f0v4";
          })

          # zsh history save/restore fixes
          (pkgs.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/tmux-plugins/tmux-resurrect/pull/285.patch";
            sha256 = "1bdvr7vj459f0kwvgvmsh1br06wk2w5hr1zjc2jfhab6mw1wb084";
          })

          # basename match strategy
          (pkgs.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/tmux-plugins/tmux-resurrect/pull/286.patch";
            sha256 = "033x10g8agkm5vswiyg0mjqswbq1n07927b0py6q9rc2g8r95k08";
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
      set -g @resurrect-processes 'mosh-client man "~yarn watch"'
      set -g @resurrect-save-command-strategy 'cmdline'
      set -g @resurrect-process-match-strategy 'basename'
      #set -g @resurrect-strategy-nvim 'session'
      #set -g @resurrect-save-shell-history 'on'

      # continuum options
      set -g @continuum-save-interval '15'
      set -g @continuum-restore 'on'
    '';
  };
}
