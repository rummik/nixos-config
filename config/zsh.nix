{ pkgs, lib, ft, ... }:

let

  inherit (lib) mkBefore optionalString;
  inherit (pkgs.stdenv) isDarwin;

in

{
  # disable zsh-newuser-install
  environment.etc."zshenv".text = mkBefore ''${ft.zsh}
    function zsh-newuser-install { }
  '';

  environment.shellAliases = {
    ls = "ls --color=auto";
    ll = "ls -l";
  };

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
        "wbingli/zsh-wakatime"
        "zick.kim/zsh/dug, from:gitlab"
        "zick.kim/zsh/ing, from:gitlab"
        "zick.kim/zsh/isup, from:gitlab"
        "zick.kim/zsh/please, from:gitlab"
        "zick.kim/zsh/psmin, from:gitlab"
        "zick.kim/zsh/psmin-gitflow, from:gitlab"
        "zick.kim/zsh/slowcat, from:gitlab"
        "zick.kim/zsh/tailf, from:gitlab"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-syntax-highlighting, defer:2"
      ];
    };

    interactiveShellInit = ''${ft.zsh}
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

      bindkey "^[[3~" delete-char
      bindkey "^[3;5~" delete-char

      ${optionalString isDarwin ''${ft.zsh}
      # the interpreter gets kinda wonk for ack on Nix-Darwin for some reason
      function ack {
        $(head -n1 $(which -p ack) | tail -c +3) \
          $(which -p ack) $@
      }
      ''}

      # sillyness because zprofile contains shell aliases
      if [[ ! $__ETC_ZPROFILE_SOURCED ]]; then
        source /etc/zprofile
      fi
    '';
  };
}
