{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (pkgs) zshPlugins zshPackages;
in {
  home.packages =
    (with pkgs; [
      any-nix-shell
    ])
    ++ (with zshPackages; [
      revolver
      zunit
    ]);

  programs.zsh = {
    enable = true;

    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    # VTE is broken on Nix-Darwin, so we're limiting to just linux
    #enableVteIntegration = lib.mkIf pkgs.stdenv.isLinux true;

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -l";
    };

    initExtra = ''
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh | source /dev/stdin

      autoload -U zcalc

      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      function line-or-beginning-search-bindkeys {
        zvm_bindkey viins '^[[A' up-line-or-beginning-search
        zvm_bindkey viins '^[[B' down-line-or-beginning-search
        zvm_bindkey viins '^P' up-line-or-beginning-search
        zvm_bindkey viins '^N' down-line-or-beginning-search
        zvm_bindkey vicmd 'k' up-line-or-beginning-search
        zvm_bindkey vicmd 'j' down-line-or-beginning-search

        zvm_bindkey viins '^[3;5~' delete-char
        zvm_bindkey vicmd '^[3;5~' delete-char
      }

      zvm_after_init_commands+=(line-or-beginning-search-bindkeys)
    '';

    plugins = with pkgs.zshPlugins;
    with zshPlugins; [
      wakatime
      dug
      ing
      isup
      please
      slowcat
      tailf
    ];
  };
}
