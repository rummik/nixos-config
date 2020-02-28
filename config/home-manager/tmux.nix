{ pkgs, lib, ... }:

let

  inherit (builtins) currentSystem;
  inherit (lib) optionalString maybeEnv;
  inherit (pkgs) tmuxPlugins tmux;
  inherit (pkgs.stdenv) isLinux mkDerivation;

  defaultPrimaryColor = "green";
  defaultSecondaryColor = "green";
  defaultAccentColor = "magenta";

  resurrect-patched = (tmuxPlugins.resurrect.overrideAttrs (oldAttrs: rec {
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-resurrect";
      rev = "905abba3c3b8a1e12c7d0fa31ff7c489a75515f9";
      sha256 = "1ij3bb4y4bqj0w8m7fmlbg8vhxm7jz6g6mmclid236carixzk5dx";
    };

    patches = [
      ../tmux/resurrect-basename-match-strategy.patch
    ];
  }));

  continuum-patched = (tmuxPlugins.continuum.overrideAttrs (oldAttrs: rec {
    dependencies = [ resurrect-patched ];
  }));

  inlineScript = name: derivation {
    name = "tmuxplugin ${name}";
    rtp = "true";
  };

in

{
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

      # Status line
      set -g status-right '#{?#{!=:#(watson status),No project started.},[#[fg=bright#{themeAccentColor}]#(watson status -p) #[fg=default]started #[fg=bright#{themeSecondaryColor}]#(watson status -e)#[fg=default]],}'


      set -g status-right-length 50

      set -g status-left "[#S] #h "
      set -g status-left-length 30

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
      { plugin = yank; }
      { plugin = sensible; }
      { plugin = pain-control; }

      {
        plugin = inlineScript "remap split";

        extraConfig = /* tmux */ ''
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

        extraConfig = /* tmux */ ''
          set -g @resurrect-capture-pane-contents "on"
          set -g @resurrect-processes "mosh-client man '~yarn watch'"
          ${optionalString isLinux /* tmux */ ''
          set -g @resurrect-save-command-strategy "linux_procfs"
          ''}
          set -g @resurrect-process-match-strategy "basename"
          set -g @resurrect-strategy-nvim "session"
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

