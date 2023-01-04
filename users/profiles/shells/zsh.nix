{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (pkgs) zshPlugins zshPackages;
in {
  home.packages = with zshPackages; [
    revolver
    zunit
  ];

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

    initExtraBeforeCompInit = ''
      autoload -U zcalc

      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      ZVM_INIT_MODE=sourcing

    '';

    initExtra = ''
      # function zvm_after_init {
        zvm_bindkey viins '^[[A' up-line-or-beginning-search
        zvm_bindkey viins '^[[B' down-line-or-beginning-search
        zvm_bindkey viins '^P' up-line-or-beginning-search
        zvm_bindkey viins '^N' down-line-or-beginning-search
        zvm_bindkey vicmd 'k' up-line-or-beginning-search
        zvm_bindkey vicmd 'j' down-line-or-beginning-search

        zvm_bindkey viins '^[3;5~' delete-char
        zvm_bindkey vicmd '^[3;5~' delete-char
     # }
    '';

    plugins = with zshPlugins; [
      # any-nix-shell
      # wakatime-zsh-plugin
      zsh-autocomplete
      dug
      fast-syntax-highlighting
      just-completions
      ing
      isup
      nix-zsh-completions
      please
      slowcat
      tailf
      zsh-autosuggestions
      zsh-completions
      zsh-vi-mode
    ];
  };
}
