{
  programs.nixvim = {
    # Config isn't wired in yet
    # https://github.com/pta2002/nixvim/issues/70
    plugins.barbar = {
      enable = true;
      # autoHide = true;
      # closeable = false; # Disable close button
      # TODO: set pin icon
    };

    maps.normal = {
      # Reordering tabs
      "<m-s-j>" = "<cmd>BufferMoveNext<cr>";
      "<m-s-k>" = "<cmd>BufferMovePrevious<cr>";
      "<m-p>" = "<cmd>BufferPin<cr>";

      # Navigating tabs
      "<m-j>" = "<cmd>BufferNext<cr>";
      "<m-k>" = "<cmd>BufferPrevious<cr>";
      "<m-1>" = "<cmd>BufferGoto 1<cr>";
      "<m-2>" = "<cmd>BufferGoto 2<cr>";
      "<m-3>" = "<cmd>BufferGoto 3<cr>";
      "<m-4>" = "<cmd>BufferGoto 4<cr>";
      "<m-5>" = "<cmd>BufferGoto 5<cr>";
      "<m-6>" = "<cmd>BufferGoto 6<cr>";
      "<m-7>" = "<cmd>BufferGoto 7<cr>";
      "<m-8>" = "<cmd>BufferGoto 8<cr>";
      "<m-9>" = "<cmd>BufferGoto 9<cr>";
      "<m-0>" = "<cmd>BufferLast<cr>";

      # Close tab
      "<m-x>" = "<cmd>BufferClose<cr>";
    };
  };
}
