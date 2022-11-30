{
  inputs,
  pkgs,
  ...
}: {
  programs.nixvim.plugins.treesitter = {
    enable = true;
    indent = true;

    disabledLanguages = [
      "fish"
      "help"
      "tsx"
      "typescript"
    ];

    # This lets us temporarily create an override to update nvim-treesitter
    # See /overlays/knix.nix
    nixGrammars = false;
    ensureInstalled = [];
  };
}
