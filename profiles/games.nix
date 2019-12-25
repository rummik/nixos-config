{ pkgs, ... }:

{
  imports = [
    ../config/steam.nix
    ../config/lutris.nix
  ];

  environment.systemPackages = with pkgs; [
    minetest
    multimc
  ];
}
