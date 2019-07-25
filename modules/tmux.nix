{ config, pkgs, lib, ... }:

let

  inherit (lib) mkOption mkIf mkAfter mkMerge literalExample types;
  inherit (pkgs.stdenv) isLinux isDarwin;

  cfg = config.programs.tmux;

  defaultPrimaryColor = "magenta";
  defaultSecondaryColor = "green";

  colors = [ "magenta" "green" "cyan" "red" "blue" "yellow" ];

in

{
  options = {
    programs.tmux = {
      plugins = mkOption {
        default = [];
        example = literalExample "[ pkgs.tmuxPlugins.resurrect ]";
        type = types.listOf types.package;
        description = "List of TMUX plugins.";
      };

      theme = {
        primaryColor = mkOption {
          default = defaultPrimaryColor;
          example = "magenta";
          type = types.enum colors;
          description = "Primary theme color.";
        };

        secondaryColor = mkOption {
          default = defaultSecondaryColor;
          example = "green";
          type = types.enum colors;
          description = "Secondary theme color.";
        };
      };

      extraConfig = mkOption {
        default = "";
        example = "";
        type = types.string;
        description = "Text to be inserted into tmux.conf.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc."tmux.conf".text = mkAfter /* tmux */ ''
      set-option -g pane-active-border-fg bright${cfg.theme.secondaryColor}
      set-option -g pane-border-fg brightblack
      set-option -g display-panes-colour ${cfg.theme.primaryColor}
      set-option -g display-panes-active-colour brightred
      set-option -g clock-mode-colour brightwhite
      set-option -g mode-bg ${cfg.theme.secondaryColor}
      set-option -g mode-fg brightwhite
      set-window-option -g window-status-bg black
      set-window-option -g window-status-fg bright${cfg.theme.primaryColor}
      set-window-option -g window-status-current-bg black
      set-window-option -g window-status-current-fg brightwhite
      set-window-option -g window-status-bell-bg black
      set-window-option -g window-status-bell-fg brightred
      set-window-option -g window-status-activity-bg black
      set-window-option -g window-status-activity-fg brightred
      set -g status-bg black
      set -g status-fg bright${cfg.theme.secondaryColor}
      set -g message-bg ${cfg.theme.secondaryColor}
      set -g message-fg brightwhite

      ${lib.concatStrings (map (x: "run-shell ${x.rtp}\n") cfg.plugins)}
    '';

    programs.tmux =
      if isDarwin then
        { tmuxConfig = cfg.extraConfig; }
      else
        { extraTmuxConf = cfg.extraConfig; };
  };
}
