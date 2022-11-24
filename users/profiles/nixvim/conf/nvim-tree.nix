{
  programs.nixvim = {
    plugins.nvim-tree = {
      enable = true;
      diagnostics.enable = true;
      git.enable = true;
    };
  };
}
