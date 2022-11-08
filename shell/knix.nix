{pkgs, ...}: let
  inherit
    (pkgs)
    nixUnstable
    alejandra
    git-crypt
    just
    nil
    shfmt
    ;

  pkgWithCategory = category: package: {inherit package category;};

  lsp = pkgWithCategory "language server";
  linter = pkgWithCategory "linter";
  general = pkgWithCategory "general commands";
in {
  commands = [
    #(general just)
    (general git-crypt)
    (general nixUnstable)

    (linter alejandra)
    #(linter prettier)
    (linter shfmt)

    (lsp nil)
  ];
}
