{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs.zshPackages; [ revolver zunit ];

  programs.zsh = {
    enable = true;

    # disable completion; zsh-autocomplete will handle it
    enableCompletion = false;

    # VTE is broken on Nix-Darwin, so we're limiting to just linux
    #enableVteIntegration = lib.mkIf pkgs.stdenv.isLinux true;

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -l";
    };

    initExtraBeforeCompInit =
      /*
      zsh
      */
      ''
        autoload -U zcalc

        autoload -U up-line-or-beginning-search
        autoload -U down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search

        ZVM_INIT_MODE=sourcing

        zmodload -i zsh/complist

        WORDCHARS='''

        unsetopt menu_complete   # do not autoselect the first completion entry
        unsetopt flowcontrol
        setopt auto_menu         # show completion menu on successive tab press
        setopt complete_in_word
        setopt always_to_end

        bindkey -M menuselect '^o' accept-and-infer-next-history
        zstyle ':completion:*:*:*:*:*' menu select

        # disable case sensitive completion
        zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'


        autoload -Uz compinit && compinit
      '';

    initExtra =
      /*
      zsh
      */
      ''
         # function zvm_after_init {
           # zvm_bindkey viins '^[[A' up-line-or-beginning-search
           # zvm_bindkey viins '^[[B' down-line-or-beginning-search
           zvm_bindkey viins '^P' up-line-or-beginning-search
           zvm_bindkey viins '^N' down-line-or-beginning-search
           zvm_bindkey vicmd 'k' up-line-or-beginning-search
           zvm_bindkey vicmd 'j' down-line-or-beginning-search

           # zvm_bindkey viins '^P' up-line-or-history
           # zvm_bindkey viins '^N' down-line-or-history
           #
           # zvm_bindkey viins '\ek' up-line-or-search
           # zvm_bindkey viins '\ej' down-line-or-select

           zvm_bindkey viins '^[3;5~' delete-char
           zvm_bindkey vicmd '^[3;5~' delete-char
        # }
      '';

    plugins = with pkgs.zshPlugins; [
      # any-nix-shell
      # wakatime-zsh-plugin
      # dug
      # ing
      # isup
      # please
      # slowcat
      # tailf

      just-completions
      # nix-zsh-completions
      zsh-completions

      fast-syntax-highlighting
      # zsh-autocomplete
      zsh-autosuggestions
      zsh-vi-mode
    ];
  };
}
