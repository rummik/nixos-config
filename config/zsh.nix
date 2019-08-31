{ lib, ... }:

{
  environment.pathsToLink = [ "/share/zsh" ];

  programs.zsh = {
    enable = true;

    # Prevent NixOS from clobbering prompts
    # See: https://github.com/NixOS/nixpkgs/pull/38535
    promptInit = lib.mkDefault "";
  };
}
