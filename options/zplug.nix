{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh.zplug;
  pkg = (pkgs.callPackage ../pkgs/zplug/default.nix { });
in
  {
    options = {
      programs.zsh.zplug = {
        enable = mkOption {
          default = false;
          description = "Enable zplug.";
        };

        theme = mkOption {
          type = types.str;
          default = "";
          description = "Repository of ZSH theme to use.";
        };

        plugins = mkOption {
          type = types.listOf(types.str);
          default = [];
          description = "List of plugins to load.";
          example = [
            "'lib/completion', from:oh-my-zsh"
            "'zsh-users/zsh-syntax-highlighting', defer:2"
          ];
        };

        selfManage = mkOption {
          default = false;
          description = ''
            Whether or not zplug should handle updating itself instead of through Nix.
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [ pkg ];

      # Prevent zsh from overwriting user's prompt
      programs.zsh.promptInit = mkIf (cfg.theme != "") (mkDefault "");

      programs.zsh.interactiveShellInit = mkBefore(with builtins; ''
        source ${pkg}/share/zplug/init.zsh

        ${optionalString (stringLength(cfg.theme) > 0) "zplug '${cfg.theme}', as:theme"}
        ${optionalString (cfg.selfManage) "zplug 'zplug/zplug', hook-build:'zplug --self-manage'"}
        ${optionalString (length(cfg.plugins) > 0) concatMapStringsSep "\n" (x: "zplug " + x) cfg.plugins}

        if ! zplug check; then
          zplug install
        fi

        zplug load
      '');
    };
  }
