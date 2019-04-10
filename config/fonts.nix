{ lib, pkgs, isLinux, isDarwin, ... }:

let
  inherit (lib) optional optionalAttrs;
in
  {
    fonts =
      {
        fonts =
          with pkgs; [
            fira
            fira-mono
            fira-code
          ]
          ++ optional isLinux emojione;
      }

      // optionalAttrs isDarwin {
        enableFontDir = true;
      };
  }
