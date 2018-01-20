{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    nvm = {
      enable = true;
      autoUse = true;
    };

    zplug = {
      enable = true;
      theme = "rummik/zsh-theme";

      plugins = [
        "'rummik/zsh-psmin'"
        "'rummik/zsh-isup'"
        "'rummik/9k1.us'"
        "'zsh-users/zsh-completions'"
        "'plugins/vi-mode', from:oh-my-zsh"
        "'lib/completion', from:oh-my-zsh"
        "'lib/history', from:oh-my-zsh"
        "'zsh-users/zsh-syntax-highlighting', defer:2"
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
