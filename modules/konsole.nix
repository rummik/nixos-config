{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.konsole;

  profileColorsSubModule = types.submodule (
    { ... }: {
      options = {
        foregroundColor = mkOption {
          type = types.str;
          description = "The foreground color.";
        };

        backgroundColor = mkOption {
          type = types.str;
          description = "The background color.";
        };

        boldColor = mkOption {
          default = null;
          type = types.nullOr types.str;
          description = "The bold color, null to use same as foreground.";
        };

        palette = mkOption {
          type = types.listOf types.str;
          description = "The terminal palette.";
        };
      };
    }
  );

  profileSubModule = types.submodule (
    { name, config, ... }: {
      options = {
        default = mkOption {
          default = false;
          type = types.bool;
          description = "Whether this should be the default profile.";
        };

        visibleName = mkOption {
          type = types.str;
          description = "The profile name.";
        };

        colors = mkOption {
          default = null;
          type = types.nullOr profileColorsSubModule;
          description = "The terminal colors, null to use system default.";
        };

        cursorShape = mkOption {
          default = "block";
          type = types.enum [ "block" "ibeam" "underline" ];
          description = "The cursor shape.";
        };

        font = mkOption {
          default = null;
          type = types.nullOr types.str;
          description = "The font name, null to use system default.";
        };

        scrollOnOutput = mkOption {
          default = true;
          type = types.bool;
          description = "Whether to scroll when output is written.";
        };

        showScrollbar = mkOption {
          default = true;
          type = types.bool;
          description = "Whether the scroll bar should be visible.";
        };

        scrollbackLines = mkOption {
          default = 10000;
          type = types.nullOr types.int;
          description =
            ''
              The number of scrollback lines to keep, null for infinite.
            '';
        };
      };
    }
  );

  #kreadconfig5
  #kwriteconfig5
 
in
  {
    meta.maintainers = with maintainers; rummik;

    options = {
      programs.konsole = {
        enable = mkEnableOption "Konsole";

        showMenubar = mkOption {
          default = true;
          type = types.bool;
          description = "Whether to show the menubar by default";
        };

        showTabBar = mkOption {
          default = "Enabled";
          type = types.enum [ "Enabled" "Disabled" "ShowTabBarWhenNeeded" ];
          description = "Whether to show the tab bar by default";
        };

        profile = mkOption {
          default = {};
          type = types.attrsOf profileSubModule;
          description = "A set of Konsole profiles";
        };

        #konsolerc
      };
    };

    config = mkIf cfg.enable {
      home.packages = [ pkgs.kdeApplications.konsole ];

      programs.konsole.konsolerc.iniContent = {
        "KonsoleWindow".ShowMenubarByDefault = options.showMenubar;
        "TabBar".TabBarVisibility = options.showTabBar;

        "Desktop Entry".DefaultProfile = "Default.profile";
      };

      xdg.configFile."konsolerc".text = generators.toINI {} cfg.konsolerc.iniContent;
      xdg.dataFile."konsole/Default.profile".text = generators.toINI {} cfg.defaultProfile.iniContent;
    };
  }
