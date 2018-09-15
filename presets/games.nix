{ config, pkgs, ... }:
{
  imports = [
    ../cfgs/steam.nix
  ];

  environment.systemPackages = with pkgs; [
    minetest
    multimc
  ];
}
