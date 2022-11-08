{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.stdenv) isLinux isx86_64;
in {
  programs.firefox = {
    # Just going to limit this to x86_64 Linux
    enable = lib.mkIf (isLinux && isx86_64) true;

    # error: cannot build '/nix/store/...-source.drv' during evaluation because the option 'allow-import-from-derivation' is disabled
    # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    #   auto-tab-discard
    #   dark-scroll-for-tweetdeck
    #   darkreader
    #   facebook-container
    #   header-editor
    #   https-everywhere
    #   multi-account-containers
    #   plasma-integration
    #   ublock-origin
    #   vim-vixen
    #   zoom-page-we
    # ];
  };
}
