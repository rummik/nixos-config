{ config, pkgs, lib, ... }:

{
  imports = [
    ../options/zplug.nix
  ];

  # disable zsh-newuser-install
  environment.etc."zshenv".text = lib.mkBefore ''
    zsh-newuser-install() { }
  '';

  programs.zsh = {
    enable = true;

    zplug = {
      enable = true;
      theme = "zick.kim/zsh/theme, from:gitlab";

      plugins = [
        "chisui/zsh-nix-shell"
        "lib/completion, from:oh-my-zsh"
        "lib/history, from:oh-my-zsh"
        "plugins/vi-mode, from:oh-my-zsh"
        "zick.kim/zsh/dug, from:gitlab"
        "zick.kim/zsh/ing, from:gitlab"
        "zick.kim/zsh/isup, from:gitlab"
        "zick.kim/zsh/please, from:gitlab"
        "zick.kim/zsh/psmin, from:gitlab"
        "zick.kim/zsh/slowcat, from:gitlab"
        "zick.kim/zsh/tailf, from:gitlab"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-syntax-highlighting, defer:2"
      ];
    };

    interactiveShellInit = ''
      autoload -U zcalc

      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search

      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      bindkey '^[[A' up-line-or-beginning-search
      bindkey '^[[B' down-line-or-beginning-search
      bindkey '^P' up-line-or-beginning-search
      bindkey '^N' down-line-or-beginning-search
      bindkey -M vicmd 'k' up-line-or-beginning-search
      bindkey -M vicmd 'j' down-line-or-beginning-search
    '';
  };
}
