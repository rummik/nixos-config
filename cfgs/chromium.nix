{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.chromium ];

  nixpkgs.config.chromium.enablePepperFlash = true;

  environment.variables = {
    BROWSER = pkgs.lib.mkOverride 0 "chromium";
  };
}
