{ pkgs, lib, ... }:
let
  helpers = import ../helpers.nix { inherit lib; };
in
{
  programs.nixvim = {
    maps.normal = {
      "<leader>sl" = "<cmd>SessionManager load_session<cr>";
      "<leader>ss" = "<cmd>SessionManager save_current_session<cr>";
      "<leader>sd" = "<cmd>SessionManager delete_session<cr>";
    };

    globals.sessionoptions = [
      "blank"
      "buffers"
      "curdir"
      "folds"
      "help"
      "tabpages"
      "terminal"
      "winsize"
      "globals"
    ];

    extraConfigLua =
      helpers.mkPluginSetupCall "session_manager" {
        autoload_mode = helpers.mkLua "require('session_manager.config').AutoloadMode.CurrentDir";
        autosave_only_in_session = true;
      };

    # autoCmd = [{
    #   event = [ "BufWritePost" ];
    #
    #   callback = { __raw = ''
    #     function ()
    #       if vim.bo.filetype ~= 'git'
    #         and not vim.bo.filetype ~= 'gitcommit'
    #         and not vim.bo.filetype ~= 'gitrebase'
    #         then require('session_manager').autosave_session() end
    #     end
    #   ''; };
    # }];

    globals.auto_save = 1;
    globals.auto_save_events = [ "InsertLeave" "TextChanged" ];

    extraPlugins = with pkgs.vimPlugins; [
      nvim-session-manager
      vim-auto-save
    ];
  };
}
