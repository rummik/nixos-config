{ pkgs, ... }: {
  programs.nixvim = {
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

    # globals.workspace_session_directory = "~/.config/nixpkgs/vim/sessions";
    globals.workspace_session_disable_on_args = true;
    maps.normal."<leader>s" = "<cmd>ToggleWorkspace<cr>";
    extraPlugins = [ pkgs.vimPlugins.vim-workspace ];
  };
}
