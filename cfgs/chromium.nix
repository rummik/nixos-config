{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.chromium ];

  nixpkgs.config.chromium.enablePepperFlash = true;

  environment.variables = {
    BROWSER = pkgs.lib.mkOverride 0 "chromium";
  };

  programs.chromium.extensions = [
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
    "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
    "klbibkeccnjlkjkiokjodocebajanakg" # The Great Suspender
  ];
}
