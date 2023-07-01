{ pkgs, ... }: {
  programs.nixvim = {
    plugins.telescope.enable = true;

    plugins.telescope.enabledExtensions = [ "ui-select" ];
    plugins.telescope.extensionConfig.ui-select = {};

    plugins.telescope.extensions.frecency.enable = true;
    plugins.telescope.extensions.fzf-native.enable = true;
    #plugins.telescope.extensions.media_files.enable = true;

    extraPlugins = with pkgs.vimPlugins; [
      telescope-ui-select-nvim
    ];

    maps.normal = {
      "<leader>ff" = "<cmd>Telescope find_files<cr>";
      "<leader>fg" = "<cmd>Telescope live_grep<cr>";
      "<leader>fb" = "<cmd>Telescope buffers<cr>";
      "<leader>fh" = "<cmd>Telescope help_tags<cr>";

      "<c-p>" = "<cmd>Telescope find_files<cr>";
      "<c-s-p>" = "<cmd>Telescope commands<cr>";
      "<c-k>" = "<cmd>Telescope buffers<cr>";
      "<c-s-k>" = "<cmd>Telescope keymaps<cr>";
    };
  };
}
