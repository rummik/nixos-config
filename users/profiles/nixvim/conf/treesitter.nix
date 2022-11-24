{
  inputs,
  pkgs,
  ...
}: {
  programs.nixvim.plugins.treesitter = {
    enable = true;
    indent = true;

    # This lets us temporarily create an override to include the injections query from tree-sitter-nix
    # See /overrides/knix.nix
    nixGrammars = false;
    ensureInstalled = [];
  };
}
