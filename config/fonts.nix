{ pkgs, lib, ... }:

let

  inherit (lib) mkMerge mkIf optional flatten;
  inherit (pkgs.stdenv) isLinux isDarwin;

in

mkMerge [
  {
    fonts.fonts = with pkgs; flatten [
      fira
      fira-mono
      fira-code
      (optional isLinux emojione)
    ];
  }

  (mkIf isDarwin {
    fonts.enableFontDir = true;
  })
]
