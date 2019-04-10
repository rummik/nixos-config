{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ sc-controller ];

  nixpkgs.config.packageOverrides = pkgs: {
    sc-controller = pkgs.sc-controller.overrideAttrs (oldAttrs: rec {
      patches = [ ./sc-controller.patch ];
    });
  };
} 
