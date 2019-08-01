{
  home.sessionVariables = {
    FZF_DEFAULT_OPTS = ''
       --color=dark
       --color=fg:7,hl:9
       --color=fg+:15,bg+:16,hl+:9
       --color=info:11,prompt:8,header:14
       --color=pointer:8,marker:8
       --color=spinner:13
       --filepath-word --no-bold
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
