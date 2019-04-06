{ config, lib, pkgs, isLinux, isDarwin, ... }:

let
  inherit (lib) optional optionals optionalAttrs;
in
  {
    imports =
      [
        ../cfgs/htop.nix
        ../cfgs/neovim.nix
        ../cfgs/tmux.nix
        ../cfgs/zsh.nix
        ../options
      ]

      ++ optionals isLinux [
        ../presets/hosts.nix
        ../presets/users.nix
      ];

      environment.systemPackages =
        (with pkgs; [
          ack
          curl
          file
          gnupg
          mosh
          nix-prefetch-git
          nmap
          pv
          telnet
          unzip
          w3m
          wget
          youtube-dl
          zip

          git
          gitAndTools.git-hub
          gitAndTools.hub
          gitAndTools.git-fame
          (callPackage ../pkgs/lab/default.nix { })
        ])
        ++ optional isLinux pkgs.whois
        ++ optional isDarwin pkgs.coreutils;

        nixpkgs.config.allowUnfree = true;
      }

      // optionalAttrs isLinux {
        services.gpm.enable = true;

        time.timeZone = "America/New_York";

        networking.firewall.enable = true;

        i18n = {
          consoleFont = "Lat2-Terminus16";
          defaultLocale = "en_US.UTF-8";
          consoleUseXkbConfig = true;
        };

        services.xserver = {
          layout = "us";
          xkbOptions = "caps:escape,compose:prsc";
        };

        system.stateVersion = "18.09";
      }

      // optionalAttrs isDarwin {
        system.stateVersion = 3;
      }
