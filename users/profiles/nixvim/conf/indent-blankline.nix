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
    # options.listchars = "tab:»·,space:·,extends:→,precedes:←,nbsp:␣,eol:↴,trail:•";
    options.listchars = "tab:» ,space: ,extends:→,precedes:←,nbsp:␣,trail:•";

    highlight = {
      IndentBlanklineIndent1.fg = "#302C25";
      IndentBlanklineIndent2.fg = "#35302B";
      IndentBlanklineIndent3.fg = "#283329";
      IndentBlanklineIndent4.fg = "#163632";
      IndentBlanklineIndent5.fg = "#112F3F";
      IndentBlanklineIndent6.fg = "#36283D";
    };

    extraConfigLua =
      helpers.mkPluginSetupCall "indent_blankline" {
        show_current_context = true;
        # show_current_context_start = true;
        # show_end_of_line = true;
        space_char_blankline = " ";
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
