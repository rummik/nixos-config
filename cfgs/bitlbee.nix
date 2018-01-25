{ config, pkgs, ... }:

with import <nixpkgs> {};
{
  services.bitlbee = {
    enable = true;

    plugins = with pkgs; [
      bitlbee-facebook
      bitlbee-steam

      (callPackage ../pkgs/bitlbee-mastodon/default.nix { })
      (callPackage ../pkgs/bitlbee-discord/default.nix { })
    ];

    libpurple_plugins = with pkgs; [
      telegram-purple
      purple-hangouts
    ];
  };
} 
