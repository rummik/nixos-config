{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    redshift-plasma-applet
  ];

  services.geoclue2.enable = true;
}
