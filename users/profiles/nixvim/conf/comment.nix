{
  programs.nixvim = {
    plugins.comment-nvim.enable = true;
    # Neovim seems to register <C-/> as <C-_>
    maps.normal."<c-_>" = "<Plug>(comment_toggle_current_linewise)";
    maps.visual."<c-_>" = "<Plug>(comment_toggle_linewise_visual)";
  };
}
