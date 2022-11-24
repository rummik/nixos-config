{
  programs.nixvim = {
    plugins.telescope.enable = true;

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
