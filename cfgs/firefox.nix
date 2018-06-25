{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ firefox ];

  nixpkgs.config.firefox = {
    #enableAdobeFlash = true;
    #enableGoogleTalkPlugin = true;
  };
}
