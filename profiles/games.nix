{ config, pkgs, ... }:
{
  imports = [
    ../config/steam.nix
  ];

  environment.systemPackages = with pkgs; [
    minetest
    multimc
  ];
}
