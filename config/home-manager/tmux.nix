{ pkgs, lib, ... }:

let

  inherit (builtins) currentSystem;
  inherit (lib) optionalString maybeEnv;
  inherit (pkgs) tmuxPlugins;
  inherit (pkgs.stdenv) isLinux mkDerivation;

  defaultPrimaryColor = "green";
  defaultAccentColor = "magenta";

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

      # Status line
      set -g status-right " "
      set -g status-right-length 30

      set -g status-left "[#S] #h "
      set -g status-left-length 30

      # Pane resize options
      set -g main-pane-width 127
      set -g main-pane-height 45

      # Use system prefix
      if "[[ ! -z $tmuxPrefixKey ]]" "\
        unbind #{prefix} \
        set -g prefix C-$tmuxPrefixKey \
        bind C-$tmuxPrefixKey send-prefix \
        bind $tmuxPrefixKey last-window \
      "

      # Profile colors
      if "[[ -z $themeAccentColor ]]"   "setenv -g themeAccentColor ${defaultAccentColor}"
      if "[[ -z $themePrimaryColor ]]" "setenv -g themePrimaryColor ${defaultPrimaryColor}"
      if "[[ $COLORTERM == truecolor ]]" "set -ga terminal-overrides ',alacritty*:Tc'"

      set -g pane-active-border-fg "bright$themePrimaryColor"
      set -g pane-border-fg "brightblack"
      set -g display-panes-colour "$themeAccentColor"
      set -g display-panes-active-colour "brightred"
      set -g clock-mode-colour "brightwhite"
      set -g mode-bg "$themePrimaryColor"
      set -g mode-fg "brightwhite"
      set -gw window-status-bg "black"
      set -gw window-status-fg "bright$themeAccentColor"
      set -gw window-status-current-bg "black"
      set -gw window-status-current-fg "brightwhite"
      set -gw window-status-bell-bg "black"
      set -gw window-status-bell-fg "brightred"
      set -gw window-status-activity-bg "black"
      set -gw window-status-activity-fg "brightred"
      set -g status-bg "black"
      set -g status-fg "bright$themePrimaryColor"
      set -g message-bg "$themePrimaryColor"
      set -g message-fg "brightwhite"
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

