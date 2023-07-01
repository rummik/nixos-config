{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkMerge mkIf optional flatten;
  inherit (pkgs.stdenv) isLinux isDarwin;
in
  mkMerge [
    {
      fonts.fonts = with pkgs;
        flatten [
          fira
          fira-mono
          fira-code
          (nerdfonts.override { fonts = [
            "FiraCode"
            "FiraMono"
          ]; })
          material-design-icons
          (optional isLinux emojione)
        ];
    }

    (mkIf isDarwin {
      fonts.enableFontDir = true;
    })
  ]
