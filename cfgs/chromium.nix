{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ chromium ];

  nixpkgs.config.chromium.enablePepperFlash = true;

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
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
      "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
      "klbibkeccnjlkjkiokjodocebajanakg" # The Great Suspender
    ];

    # Enable Chrome Cast
    extraOpts = {
      EnableMediaRouter = true;
      ShowCastIconInToolbar = true;
    };
  };
}
