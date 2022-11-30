# see ../../users/profiles/zsh.nix for actual config

{lib, ...}: {
  environment.pathsToLink = ["/share/zsh"];
  programs.zsh = {
    enable = true;
    # disable completion because we'll do this elsewhere
    enableCompletion = false;
  };
}
