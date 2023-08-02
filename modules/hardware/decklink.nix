{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.decklink;
  kernelPackages = config.boot.kernelPackages;
in
{
  options.hardware.decklink.enable = mkEnableOption "hardware support for the Blackmagic Design Decklink audio/video interfaces";

  config = mkIf cfg.enable {
    boot.extraModulePackages = [ kernelPackages.decklink ];
    systemd.packages = [ pkgs.blackmagic-desktop-video ];
  };
}
