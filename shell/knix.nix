{ pkgs, ... }: let
  inherit
    (pkgs)
    alejandra
    deadnix
    git-crypt
    just
    nil
    nixfmt
    nixpkgs-fmt
    shfmt
    statix
    ;

  inherit
    (pkgs.nodePackages)
    prettier
    ;

  pkgWithCategory = category: package: {
    inherit package category;
  };

  lsp = pkgWithCategory "language server";
  linter = pkgWithCategory "linter";
  formatter = pkgWithCategory "formatter";
  general = pkgWithCategory "general commands";
in {
  commands = [
    (general just)
    (general git-crypt)

    (formatter alejandra)
    (formatter nixfmt)
    (formatter nixpkgs-fmt)

    (linter deadnix)
    (linter statix)

    (formatter prettier)
    (formatter shfmt)

    (lsp nil)
  ];
}
