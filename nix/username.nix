{
  config ? {},
  lib,
  pkgs,
}:


let

  inherit (import ../channels) __nixPath;
  inherit (import <home-manager/modules/home-environment.nix> { inherit config lib pkgs; }) config;

in

config.home.username
