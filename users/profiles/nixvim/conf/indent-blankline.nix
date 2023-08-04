{
  pkgs,
  lib,
  ...
}:

let
  helpers = import ../helpers.nix { inherit lib; };
in

{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.indent-blankline-nvim-lua ];

    options.list = true;
    options.listchars = "tab:|->,lead:·,space: ,trail:•,extends:→,precedes:←,nbsp:␣";
    # options.listchars = "tab:┊->,lead:·,space: ,trail:•,extends:→,precedes:←,nbsp:␣,eol:↴";

    highlight = {
      IndentBlanklineContextChar.fg = "#787572";
      IndentBlanklineIndent1.fg = "#372C25";
      IndentBlanklineIndent2.fg = "#35302B";
      IndentBlanklineIndent3.fg = "#283329";
      IndentBlanklineIndent4.fg = "#163632";
      IndentBlanklineIndent5.fg = "#112F3F";
      IndentBlanklineIndent6.fg = "#36283D";
    };

    extraConfigLua =
      helpers.mkPluginSetupCall "indent_blankline" rec {
        # strict_tabs = true;
        use_treesitter = true;
        use_treesitter_scope = true;
        show_end_of_line = false;
        no_tab_character = false;
        disable_warning_message = false;

        show_trailing_blankline_indent = true;
        show_current_context = true;
        # show_current_context_start = true;
        # show_current_context_start_on_current_line = true;

        char = "┊";
        char_blankline = " ";
        context_char = "│";
        context_char_blankline = "┊";
        # indent_blankline_char_list = [
        #   "│"
        #   "╎"
        #   "┆"
        #   "┊"
        # ];

        space_char_highlight_list = char_highlight_list;
        space_char_blankline_highlight_list = char_highlight_list;

        char_highlight_list = [
          "IndentBlanklineIndent1"
          "IndentBlanklineIndent2"
          "IndentBlanklineIndent3"
          "IndentBlanklineIndent4"
          "IndentBlanklineIndent5"
          "IndentBlanklineIndent6"
        ];

      };
  };
}
