{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../config/steam.nix
  ];

  environment.systemPackages =
    (with pkgs; [
      minetest
      multimc
    ])

    ++

    (with pkgs-unstable; [
      lutris
    ]);
}
