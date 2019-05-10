{ config, lib, pkgs, __nixPath, isLinux, isDarwin, ... }:

let
  inherit (lib) optional optionals optionalAttrs;
in
  {
    imports =
      [
        "config/htop.nix"
        "config/neovim.nix"
        "config/tmux.nix"
        "config/zsh.nix"
      ]

      ++ optionals isLinux [
        "profiles/hosts.nix"
        "profiles/users.nix"
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

          cht-sh

          git
          gitAndTools.git-hub
          gitAndTools.hub
          gitAndTools.git-fame
          lab
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

        system.stateVersion = "19.03";
      }

      // optionalAttrs isDarwin {
        system.stateVersion = 3;
      }
