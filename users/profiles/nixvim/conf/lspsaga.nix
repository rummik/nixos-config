{
  lib,
  pkgs,
  ...
}:
let
  helpers = import ../helpers.nix { inherit lib; };
in
{
  programs.nixvim = {
    # plugins.lspsaga.enable = true;
    extraPlugins = [
      pkgs.vimPlugins.lspsaga-nvim
    ];

    extraConfigLua = helpers.mkPluginSetupCall "lspsaga" (helpers.camelToSnakeAttrs {
      symbolInWinbar = {
        enable = false;
      };
      scrollPreview = {
        scrollDown = "<C-j>";
        scrollUp = "<C-k>";
      };
    });

    maps = {
      # normal = {
      #   "gh" = "<cmd>Lspsaga lsp_finder<CR>";
      #   "gr" = "<cmd>Lspsaga rename<CR>";
      #   "gd" = "<cmd>Lspsaga peek_definition<CR>";
      # };
      # normalVisual."<leader>ca" = "<cmd>Lspsaga code_action<CR>";
    };
  };
}
