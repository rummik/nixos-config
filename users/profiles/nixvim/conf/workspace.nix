{pkgs, ...}: {
  programs.nixvim = {
    globals.workspace_autosave_ignore = ["gitcommit"];
    globals.workspace_session_disable_on_args = true;
    maps.normal."<leader>s" = "<cmd>ToggleWorkspace<cr>";
    extraPlugins = [ pkgs.vimPlugins.vim-workspace ];
  };
}
