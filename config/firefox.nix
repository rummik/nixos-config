{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox
    plasma-browser-integration
  ];

  nixpkgs.config.firefox = {
    #enableAdobeFlash = true;
    #enableGoogleTalkPlugin = true;
    enablePlasmaBrowserIntegration = true;
  };
}
