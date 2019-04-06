{ lib, pkgs, isLinux, isDarwin, ... }:

let
  inherit (lib) optionalAttrs;
in
  {
    fonts.fonts = with pkgs; [
      fira
      fira-mono
      fira-code
    ];
  }

  // optionalAttrs isLinux {
    fonts.fonts = with pkgs; [ emojione ];
  }

  // optionalAttrs isDarwin {
    fonts.enableFontDir = true;
  }
