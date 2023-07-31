{
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../helpers.nix { inherit lib; }) camelToSnakeAttrs mkPluginSetupCall;
in
{
  programs.nixvim = {
    # plugins.lspsaga.enable = true;
    extraPlugins = [
      pkgs.vimPlugins.lspsaga-nvim
    ];

    extraConfigLua = mkPluginSetupCall "lspsaga" (camelToSnakeAttrs {
      symbolInWinbar = {
        enable = false;
      };

      lightbulb = {
        sign = false;
      };

      ui.codeAction = " "; #󰌵"; #󰌶󱠂";

      scrollPreview = {
        scrollDown = "<C-j>";
        scrollUp = "<C-k>";
      };
    });

    maps = {
      normal = {
        "gh" = "<cmd>Lspsaga lsp_finder<CR>";
        "gr" = "<cmd>Lspsaga rename<CR>";
        "gd" = "<cmd>Lspsaga peek_definition<CR>";
      };
      normalVisualOp."<leader>ca" = "<cmd>Lspsaga code_action<CR>";
    };
  };
}
