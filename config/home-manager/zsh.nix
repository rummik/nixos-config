{ pkgs, lib, ... }:

let

  inherit (lib) optionalString;
  inherit (pkgs) fetchFromGitHub fetchFromGitLab;
  inherit (pkgs.stdenv) isDarwin;

in

{
  home.packages =
    (with pkgs; [
      any-nix-shell
    ])

    ++

    (with pkgs.zshPackages; [
      revolver
      zunit
    ]);

  programs.zsh = {
    enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -l";
    };

    initExtra = /* zsh */ ''
      autoload -U zcalc
      autoload -Uz compinit && compinit

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

      ${optionalString isDarwin /* zsh */ ''
      # the interpreter gets kinda wonk for ack on Nix-Darwin for some reason
      function ack {
        $(head -n1 $(which -p ack) | tail -c +3) \
          $(which -p ack) $@
      }
      ''}
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "history" "vi-mode" ];
    };

    plugins = with pkgs.zshPlugins; [
      theme.rummik

      autosuggestions
      completions
      any-nix-shell
      #zsh-nix-shell
      nix-zsh-completions
      syntax-highlighting

      wakatime
      dug
      ing
      isup
      please
      psmin
      psmin-gitflow
      slowcat
      tailf
      vimode-cursor
    ];
  };
}
