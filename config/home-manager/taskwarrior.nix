{ config, ... }:

let

  inherit (config.home) username;

in

{
  programs.taskwarrior = {
    enable = username != "root";
  };
}
