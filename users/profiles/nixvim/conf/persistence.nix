{ pkgs, lib, ... }:
let
  helpers = import ../helpers.nix { inherit lib; };
in
{
  # programs.nixvim = {
    # globals.workspace_autosave_ignore = [ "gitcommit" ];
    # globals.workspace_session_disable_on_args = true;
    # maps.normal."<leader>s" = "<cmd>ToggleWorkspace<cr>";
    # extraPlugins = [ pkgs.vimPlugins.persistence-nvim ];

  programs.nixvim.maps.normal = {
    "<leader>s" = "<cmd>ToggleWorkspace<cr>";
  };

  programs.nixvim.extraConfigLua =
    helpers.mkPluginSetupCall "persistence" {
      # panel.enabled = false;
      # suggestion.enabled = false;
      # suggestion.auto_trigger = true;
      options = [ "globals" ];
      pre_save = helpers.mkLuaLambda /* lua */ ''
        vim.api.nvim_exec_autocmds('User', {pattern = 'SessionSavePre'})
      '';
    };
  # };
}
