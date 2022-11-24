{pkgs, ...}: let
  inherit
    (pkgs)
    alejandra
    git-crypt
    just
    nil
    nixUnstable
    rnix-lsp
    shfmt
    tree-sitter
    ;

  inherit
    (pkgs.nodePackages)
    prettier
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
    (general (tree-sitter.withPlugins (_: tree-sitter.allGrammars)))

    (linter alejandra)
    (linter prettier)
    (linter shfmt)

    (lsp nil)
    (lsp rnix-lsp)
  ];
}
