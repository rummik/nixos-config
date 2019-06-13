{ pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    plugins = [
      pkgs.obs-linuxbrowser
    ];
  };
}
