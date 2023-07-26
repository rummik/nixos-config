{ pkgs, ... }: let
  inherit (pkgs) tmuxPlugins tmux;

  defaultPrimaryColor = "green";
  defaultSecondaryColor = "green";
  defaultAccentColor = "magenta";

  resurrect-patched = tmuxPlugins.resurrect.overrideAttrs (old: {
    patches = [
      ./resurrect-basename-match-strategy.patch
    ];
  });

  continuum-patched = tmuxPlugins.continuum.overrideAttrs (old: {
    #dependencies = [ resurrect-patched ];
  });

  inlineScript = name:
    derivation {
      pname = "tmuxplugin ${name}";
      rtp = "true";
    };
in {
  programs.tmux = {
    enable = true;

    keyMode = "vi";

    extraConfig = /* tmux */ ''
      # Enable mouse support
      set -g mouse on

      # Pane resize options
      set -g main-pane-width 127
      set -g main-pane-height 45

      # All the colors
      %if #{==:$COLORTERM,truecolor}
        set -ga terminal-overrides ",alacritty*:Tc"
      %endif
      #
      # set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      # set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
      # TERM options
      set -g default-terminal "tmux-256color" # This is the correct option.
      # set -g default-terminal "xterm-256color"   # Centos 7.7 does not have tmux terminfo so we need to use xterm-256color. (DO NOT use screen-256color)
      set -ga terminal-overrides ",*256col*:Tc"  # true colous support
      set -as terminal-overrides ',*:sitm=\E[3m' # Italics support for older ncurses
      set -as terminal-overrides ',*:smxx=\E[9m' # Strikeout
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours

      # Use system prefix
      %if #{&&,#{!=:$tmuxPrefixKey,},#{!=:C-$tmuxPrefixKey,#{prefix}}}
        run -b "${tmux}/bin/tmux unbind #{prefix}"
        set -g prefix "C-$tmuxPrefixKey"
        bind "C-$tmuxPrefixKey" send-prefix
        bind "$tmuxPrefixKey" last-window
      %endif

      # Profile colors
      %if #{==:$themePrimaryColor,}
        setenv -g themePrimaryColor "${defaultPrimaryColor}"
      %endif

      %if #{==:$themeSecondaryColor,}
        setenv -g themeSecondaryColor "${defaultSecondaryColor}"
      %endif

      %if #{==:$themeAccentColor,}
        setenv -g themeAccentColor "${defaultAccentColor}"
      %endif

      # Theme
      set -g clock-mode-colour "brightwhite"
      set -g display-panes-active-colour "brightred"
      set -g display-panes-colour "$themeAccentColor"
      set -g message-style fg="brightwhite",bg="$themePrimaryColor"
      set -g mode-style fg="brightwhite",bg="$themePrimaryColor"
      set -g pane-active-border-style fg="bright$themePrimaryColor",bg="terminal"
      set -g pane-border-style fg="brightblack",bg="terminal"
      set -g status-style fg="bright$themePrimaryColor",bg="black"
      set -gw window-status-activity-style fg="brightred",bg="black"
      set -gw window-status-bell-style fg="brightred",bg="black"
      set -gw window-status-current-style fg="brightwhite",bg="black"
      set -gw window-status-style fg="bright$themeAccentColor",bg="black"
    '';

    plugins = with tmuxPlugins; [
      {
        plugin = inlineScript "status line";
        extraConfig =
          # tmux
          ''
            set -g status-left "[#S] #h "

            # Watson
            set -g status-right "#{?#{!=:#(watson status),No project started.},[#[fg=bright#{themeAccentColor}]#(watson status -p) #[fg=default]started #[fg=bright#{themeSecondaryColor}]#(watson status -e)#[fg=default]],}"

            # Battery
            set -ag status-right "#{battery_color_fg}#{battery_icon}"

            set -g status-right-length 50
            set -g status-left-length 30
          '';
      }

      { plugin = yank; }
      { plugin = open; }
      { plugin = sensible; }
      { plugin = pain-control; }
      { plugin = battery; }
      { plugin = sidebar; }

      {
        plugin = inlineScript "remap split";

        extraConfig =
          # tmux
          ''
            unbind "-"
            unbind "_"
            bind "|" split-window -h -c "#{pane_current_path}"
            bind "\\" split-window -v -c "#{pane_current_path}"
            bind "_" split-window -fh -c "#{pane_current_path}"
            bind "C-\\" split-window -fv -c "#{pane_current_path}"
            bind "c" new-window -c "~/"
          '';
      }

      {
        plugin = resurrect-patched;

        extraConfig =
          # tmux
          ''
            # need to figure out how to make this work on mac
            set -g @resurrect-save-command-strategy "linux_procfs"

            set -g @resurrect-capture-pane-contents "on"
            set -g @resurrect-processes "mosh-client man '~yarn watch'"
            set -g @resurrect-process-match-strategy "basename"
            set -g @resurrect-strategy-nvim "session"
          '';
      }

      {
        plugin = continuum-patched;

        extraConfig =
          # tmux
          ''
            set -g @continuum-save-interval "5"
            set -g @continuum-restore "on"
          '';
      }
    ];
  };
}
