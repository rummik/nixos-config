{ pkgs, config, ... }:

let

  inherit (config.home) username;

in

{
  programs.obs-studio =  {
    enable = username != "root";
    plugins = with pkgs; [
      obs-linuxbrowser
    ];
  };
}
