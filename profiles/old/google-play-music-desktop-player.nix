{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    google-play-music-desktop-player
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    google-play-music-desktop-player = pkgs.google-play-music-desktop-player.overrideAttrs (oldAttrs: rec {
      version = "4.5.0";
      name = "google-play-music-desktop-player-${version}";

      src = pkgs.fetchurl {
        url = "https://github.com/MarshallOfSound/Google-Play-Music-Desktop-Player-UNOFFICIAL-/releases/download/v${version}/google-play-music-desktop-player_${version}_amd64.deb";
        sha256 = "06h9g1yhd5q7gg8v55q143fr65frxg0khfgckr03gsaw0swin51q";
      };
    });
  };
}
