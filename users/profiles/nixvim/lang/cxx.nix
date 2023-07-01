{
  programs.nixvim.plugins.lsp.enable = true;
  programs.nixvim.plugins.lsp.servers.clangd.enable = true;
  programs.nixvim.plugins.clangd-extensions = {
    enable = true;
    enableOffsetEncodingWorkaround = true;
  };
}
