{ lib, pkgs, ... }:

let
  inherit (lib) optionalAttrs;
  inherit (lib.systems.elaborate { system = __currentSystem; }) isLinux isDarwin;
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
