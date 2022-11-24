{
  programs.nixvim.plugins.copilot.enable = true;
  programs.nixvim.maps.normal = {
    "<leader>coe" = "<cmd>Copilot enable<cr>";
    "<leader>cod" = "<cmd>Copilot disable<cr>";
    "<leader>cos" = "<cmd>Copilot status<cr>";
  };
}
