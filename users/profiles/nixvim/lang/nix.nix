{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim = {
    plugins.lsp.enable = true;
    plugins.lsp.servers.rnix-lsp.enable = true;

    extraPlugins = with pkgs.vimPlugins; [
      vim-nix
    ];
  };
}
