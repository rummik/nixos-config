{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [pkgs.vimPlugins.nvim-colorizer-lua];
    extraConfigLua = ''
      require 'colorizer'.setup {
        filetypes = {
          '*';
          css = { css = true; };
          scss = { css = true; };
          sass = { css = true; };
          less = { css = true; };
          stylus = { css = true; };
        };

        user_default_options = {
          RGB = false;
          names = false;
          RRGGBBAA = true;
          AARRGGBB = true;
        };

        buftypes = {
          '*';
          '!prompt';
          '!popup';
        };
      }
    '';
  };
}
