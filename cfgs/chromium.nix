{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ chromium ];

  nixpkgs.config.chromium = {
    enablePepperFlash = true; # Needed for Hulu
    #enableWideVine = true; # Needed for Netflix
  };

  environment.variables = {
    BROWSER = pkgs.lib.mkOverride 0 "chromium";
  };

#  networking.firewall.allowedUDPPortRanges = [
#    { from = 32768; to = 61000; }
#  ];
#
#  networking.firewall.allowedTCPPortRanges = [
#    { from = 8008; to = 8009; }
#  ];
#
#  networking.firewall.allowedUDPPorts = [
#    1900
#  ];

  programs.chromium = {
    enable = true;

    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin - https://github.com/gorhill/uBlock
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium - https://github.com/philc/vimium
      "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere - https://github.com/EFForg/https-everywhere
      "klbibkeccnjlkjkiokjodocebajanakg" # The Great Suspender - https://github.com/deanoemcke/thegreatsuspender
      "dhdgffkkebhmkfjojejmpbldmpobfkfo" # Tampermonkey - https://github.com/Tampermonkey/tampermonkey
      "hhinaapppaileiechjoiifaancjggfjm" # Last.fm scrobbler - https://github.com/web-scrobbler/web-scrobbler
      "mjoedlfflcchnleknnceiplgaeoegien" # Isometric contributions - https://github.com/jasonlong/isometric-contributions
    ];

    # Enable Chrome Cast
    extraOpts = {
      EnableMediaRouter = true;
      ShowCastIconInToolbar = true;
    };
  };
}
