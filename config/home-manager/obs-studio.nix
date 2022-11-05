{ pkgs, config, ... }:

let

  inherit (config.home) username;
  inherit (pkgs.stdenv) isLinux;

in

{
  programs.obs-studio =  {
    enable = isLinux && username != "root";

    /*plugins = with pkgs; [
      obs-linuxbrowser
    ];*/
  };
}
