{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ chromium ];

  nixpkgs.config.chromium.enablePepperFlash = true;

  environment.variables = {
    BROWSER = pkgs.lib.mkOverride 0 "chromium";
  };

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
