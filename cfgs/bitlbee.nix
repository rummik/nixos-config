{ config, pkgs, ... }:

{
  services.bitlbee = {
    enable = true;

    plugins = with pkgs; [
      bitlbee-facebook
      bitlbee-steam
    ];

    libpurple_plugins = with pkgs; [
      telegram-purple
      purple-hangouts
    ];
  };
} 
