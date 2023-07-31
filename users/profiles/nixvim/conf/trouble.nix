{
  programs.nixvim = {
    plugins.trouble = {
      enable = true;
    };

    maps.normalVisualOp = {
      "<leader>xx" = "<cmd>TroubleToggle<cr>";
      "<leader>xw" = "<cmd>TroubleToggle workspace_diagnostics<cr>";
      "<leader>xd" = "<cmd>TroubleToggle document_diagnostics<cr>";
      "<leader>xq" = "<cmd>TroubleToggle quickfix<cr>";
      "<leader>xl" = "<cmd>TroubleToggle loclist<cr>";
      "gR" = "<cmd>TroubleToggle lsp_references<cr>";
    };
  };
}
