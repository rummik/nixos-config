{ config, pkgs, ... }:

{
  services.bitlbee = {
    enable = true;

    plugins = with pkgs; [
      bitlbee-facebook
      bitlbee-steam

      (pkgs.callPackage ../pkgs/bitlbee-mastodon/default.nix { })
      (pkgs.callPackage ../pkgs/bitlbee-discord/default.nix { })
    ];

    libpurple_plugins = with pkgs; [
      telegram-purple
      purple-hangouts
    ];
  };
} 
