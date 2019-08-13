{
  environment.pathsToLink = [ "/share/zsh" ];

  programs.zsh = {
    enable = true;

    # Prevent prompt mangling
    # See: https://github.com/NixOS/nixpkgs/pull/38535
    promptInit = "";
  };
}
