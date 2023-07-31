# {
#   config,
#   inputs,
#   pkgs,
#   # lib,
#   ...
# }:
# let
#   helpers = import ../helpers.nix { inherit lib; };
# in
{
  programs.nixvim.plugins.treesitter = {
    enable = true;
    indent = true;

    disabledLanguages = [
      # "fish"
      # "help"
      # "tsx"
      # "typescript"
    ];

    # This lets us temporarily create an override to update nvim-treesitter
    # See /pkgs/default.nix
    # nixGrammars = false;
    # ensureInstalled = [];
    # parserInstallDir = "${config.xdg.dataHome}/nvim/tree-sitter";
  };

  # programs.nixvim.extraConfigLua = lib.concatStringsSep "\n" (
  #   lib.mapAttrsToList
  #     (name: grammar: helpers.toLua (
  #       helpers.mkLuaCall "vim.treesitter.require_language" [
  #         (lib.strings.replaceStrings [ "org-nvim" "ql-dbscheme" "-" ] [ "org" "dbscheme" "_" ]
  #           (lib.strings.removePrefix "tree-sitter-" name))
  #         "${grammar}/parser"
  #       ]
  #     ))
  #     pkgs.tree-sitter.builtGrammars
  # );
}
