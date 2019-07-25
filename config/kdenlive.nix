{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kdenlive
    frei0r
    gifsicle
    ffmpeg

    (pkgs.runCommand "ln-frei0r" { } /* sh */ ''
      mkdir -p $out/usr/lib
      ln -s {/run/current-system/sw,$out/usr}/lib/frei0r-1
    '')
  ];
}

