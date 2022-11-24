{pkgs, ...}: {
  programs.nixvim = {
    extraConfigLua = "require 'colorizer'.setup()";
    extraPlugins = [pkgs.vimPlugins.nvim-colorizer-lua];
  };
}
