{
  config,
  pkgs,
  ...
}: {
  services.bitlbee = {
    enable = true;

    plugins = with pkgs; [
      bitlbee-facebook
      bitlbee-steam
      bitlbee-mastodon
      bitlbee-discord
    ];

    libpurple_plugins = with pkgs; [
      telegram-purple
      purple-hangouts
    ];
  };
}
