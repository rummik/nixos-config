{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.stdenv) isLinux isx86_32;
in {
  programs.obs-studio = {
    # Only available on Linux, but not supported on x86_32
    enable = lib.mkIf (isLinux && !isx86_32) true;

    # plugins = with pkgs; [
    #   obs-linuxxbrowser
    # ];
  };
}
