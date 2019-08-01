{ pkgs, lib, ... }:

let

  inherit (lib) optionalString maybeEnv;
  inherit (pkgs) tmuxPlugins;
  inherit (pkgs.stdenv) isLinux;

  primaryColor = "magenta";
  secondaryColor = "green";

  resurrect-patched = (tmuxPlugins.resurrect.overrideAttrs (oldAttrs: rec {
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-resurrect";
      rev = "e3f05dd34f396a6f81bd9aa02f168e8bbd99e6b2";
      sha256 = "0w7gn6pjcqqhwlv7qa6kkhb011wcrmzv0msh9z7w2y931hla4ppz";
    };

    patches = [
      ../tmux/resurrect-basename-match-strategy.patch
      ../tmux/resurrect-cmdline-save-strategy.patch
    ];
  }));

  continuum-patched = (tmuxPlugins.continuum.overrideAttrs (oldAttrs: rec {
    dependencies = [ resurrect-patched ];
  }));

in

{
  programs.tmux = {
    enable = true;

    extraConfig = /* tmux */ ''
      # enable mouse support
      set -g mouse on

      set -g mode-keys vi

      # status line
      set -g status-right " "
      set -g status-right-length 30

      set -g status-left "[#S] #h "
      set -g status-left-length 30

      # Pane resize options
      set -g main-pane-width 127
      set -g main-pane-height 45

      set-option -g pane-active-border-fg bright${secondaryColor}
      set-option -g pane-border-fg brightblack
      set-option -g display-panes-colour ${primaryColor}
      set-option -g display-panes-active-colour brightred
      set-option -g clock-mode-colour brightwhite
      set-option -g mode-bg ${secondaryColor}
      set-option -g mode-fg brightwhite
      set-window-option -g window-status-bg black
      set-window-option -g window-status-fg bright${primaryColor}
      set-window-option -g window-status-current-bg black
      set-window-option -g window-status-current-fg brightwhite
      set-window-option -g window-status-bell-bg black
      set-window-option -g window-status-bell-fg brightred
      set-window-option -g window-status-activity-bg black
      set-window-option -g window-status-activity-fg brightred
      set -g status-bg black
      set -g status-fg bright${secondaryColor}
      set -g message-bg ${secondaryColor}
      set -g message-fg brightwhite
    '';

    plugins = with tmuxPlugins; [
      { plugin = yank; }
      { plugin = sensible; }

      {
        plugin = pain-control;

        extraConfig = /* tmux */ ''
          unbind-key "-"
          unbind-key "_"
          bind-key "|" split-window -h -c "#{pane_current_path}"
          bind-key "\\" split-window -v -c "#{pane_current_path}"
        '';
      }

      {
        plugin = resurrect-patched;
        extraConfig = /* tmux */ ''
          set -g @resurrect-capture-pane-contents "on"
          set -g @resurrect-processes "mosh-client man '~yarn watch'"
          ${optionalString isLinux /* tmux */ ''
          set -g @resurrect-save-command-strategy "cmdline"
          ''}
          set -g @resurrect-process-match-strategy "basename"
          #set -g @resurrect-strategy-nvim "session"
          #set -g @resurrect-save-shell-history "on"
        '';
      }

      {
        plugin = continuum-patched;
        extraConfig = /* tmux */ ''
          set -g @continuum-save-interval "15"
          set -g @continuum-restore "on"
        '';
      }
    ];
  };
}

